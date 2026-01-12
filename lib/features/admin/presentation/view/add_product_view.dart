import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_state.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

class AddProductView extends StatefulWidget {
  final ProductEntity? product; // If null, we are in "Add" mode

  const AddProductView({super.key, this.product});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _botanicalNameController = TextEditingController();
  final _familyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  // Care Profile Controllers
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _heightController = TextEditingController();
  final _potSizeController = TextEditingController();

  // Dropdown Values
  String _difficulty = "Easy";
  String _light = "Indirect Light";
  String _water = "Weekly";

  // Checkboxes
  bool _isPetFriendly = false;
  bool _isAirPurifying = false;
  bool _isTrending = false;

  // Selectors
  String? _selectedCategoryId;
  File? _selectedImage;
  File? _selectedARModel;

  // Edit Mode Initial Data (for preview)
  String? _existingImageUrl;
  String? _existingARModelUrl;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initEditMode();
    }
  }

  void _initEditMode() {
    final p = widget.product!;
    _nameController.text = p.name;
    _botanicalNameController.text = p.botanicalName ?? "";
    _familyController.text = p.family ?? "";
    _descriptionController.text = p.description;
    _priceController.text = p.price.toString();
    _stockController.text = p.stock.toString();
    
    // Care Profile
    _difficulty = p.difficulty ?? "Easy";
    _light = p.light ?? "Indirect Light";
    _water = p.water ?? "Weekly";
    _temperatureController.text = p.temperature ?? "";
    _humidityController.text = p.humidity ?? "";

    // Details
    _heightController.text = p.height ?? "";
    _potSizeController.text = p.potSize ?? "";

    // Tags
    _isPetFriendly = p.isPetFriendly ?? false;
    _isAirPurifying = p.isAirPurifying ?? false;
    _isTrending = p.isTrending ?? false;

    _selectedCategoryId = p.categoryId;
    _existingImageUrl = p.image;
    // _existingARModelUrl = p.arModel; // Assume entity has this field
  }

  @override
  void dispose() {
    _nameController.dispose();
    _botanicalNameController.dispose();
    _familyController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _heightController.dispose();
    _potSizeController.dispose();
    super.dispose();
  }

  // --- Pickers ---

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickARModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb', 'gltf'],
    );

    if (result != null) {
      setState(() {
        _selectedARModel = File(result.files.single.path!);
      });
    }
  }

  void _submit(BuildContext context, AdminProductState state) {
    if (_formKey.currentState!.validate()) {
      // Validation for Category
      if (_selectedCategoryId == null) {
        MySnackBar.showError(
          context: context,
          message: "Please select a category",
        );
        return;
      }
      // Validation for Image (Required only for new products)
      if (widget.product == null && _selectedImage == null) {
        MySnackBar.showError(
          context: context,
          message: "Please select a product image",
        );
        return;
      }

      // Find selected category name
      final category = state.categories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => state.categories.first,
      );

      final productEntity = ProductEntity(
        id: widget.product?.id,
        name: _nameController.text.trim(),
        botanicalName: _botanicalNameController.text.trim(),
        family: _familyController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        categoryId: _selectedCategoryId,
        categoryName: category.name,
        image: _existingImageUrl ?? '',
        images: widget.product?.images ?? [],
        
        // Care Profile
        difficulty: _difficulty,
        light: _light,
        water: _water,
        temperature: _temperatureController.text.trim(),
        humidity: _humidityController.text.trim(),

        // Details
        height: _heightController.text.trim(),
        potSize: _potSizeController.text.trim(),

        // Tags
        isPetFriendly: _isPetFriendly,
        isAirPurifying: _isAirPurifying,
        isTrending: _isTrending,
      );

      if (widget.product == null) {
        context.read<AdminProductBloc>().add(
          CreateProductEvent(
            product: productEntity,
            image: _selectedImage!,
            arModel: _selectedARModel,
          ),
        );
      } else {
        context.read<AdminProductBloc>().add(
          UpdateProductEvent(
            product: productEntity,
            image: _selectedImage,
            arModel: _selectedARModel,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3ED),
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Product" : "Add Product",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AdminProductBloc, AdminProductState>(
        listener: (context, state) {
          if (state.successMessage != null && !state.isActionLoading) {
            MySnackBar.showSuccess(
              context: context,
              message: state.successMessage!,
            );
            Navigator.pop(context); 
          }
          if (state.error != null && !state.isActionLoading) {
            MySnackBar.showError(context: context, message: state.error!);
          }
        },
        builder: (context, state) {
          if (state.isActionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // --- Image Upload ---
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[400]!),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : (_existingImageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        "${ApiEndpoints.serverAddress}/$_existingImageUrl",
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                      ),
                      child: _selectedImage == null && _existingImageUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  LucideIcons.imagePlus,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Tap to upload image",
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // --- Basic Info ---
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: "Product Name",
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _botanicalNameController,
                          hintText: "Botanical Name",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _familyController,
                          hintText: "Family",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _priceController,
                          hintText: "Price",
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? "Required" : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _stockController,
                          hintText: "Stock",
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? "Required" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Category ---
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Select Category",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    ),
                    items: state.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategoryId = val),
                    validator: (val) => val == null ? "Required" : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: _descriptionController,
                    hintText: "Description",
                    // maxLines: 4,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 24),

                  // --- Care Profile ---
                  Text("Care Profile", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _difficulty,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            labelText: "Difficulty",
                          ),
                          items: ["Easy", "Medium", "Expert"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _difficulty = val!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _light,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            labelText: "Light",
                          ),
                          items: ["Low Light", "Indirect Light", "Bright Light"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _light = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _water,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      labelText: "Watering",
                    ),
                    items: ["Daily", "Weekly", "Bi-weekly", "Monthly"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _water = val!),
                  ),
                  const SizedBox(height: 16),

                   Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _temperatureController,
                          hintText: "Temperature (e.g. 15-30°C)",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _humidityController,
                          hintText: "Humidity (e.g. High)",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Details ---
                  Text("Details", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _heightController,
                          hintText: "Height (e.g. 12-15\")",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _potSizeController,
                          hintText: "Pot Size (e.g. 5\")",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Tags ---
                  Text("Tags", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  CheckboxListTile(
                    title: Text("Pet Friendly", style: GoogleFonts.poppins()),
                    value: _isPetFriendly,
                    onChanged: (val) => setState(() => _isPetFriendly = val!),
                  ),
                  CheckboxListTile(
                    title: Text("Air Purifying", style: GoogleFonts.poppins()),
                    value: _isAirPurifying,
                    onChanged: (val) => setState(() => _isAirPurifying = val!),
                  ),
                  CheckboxListTile(
                    title: Text("Trending", style: GoogleFonts.poppins()),
                    value: _isTrending,
                    onChanged: (val) => setState(() => _isTrending = val!),
                  ),
                  
                  const SizedBox(height: 30),

                  // --- AR Model ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.box, color: Color(0xFF3A7F5F)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedARModel != null
                                ? _selectedARModel!.path.split('/').last
                                : (_existingARModelUrl != null
                                      ? "Existing 3D Model"
                                      : "No 3D Model selected"),
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: _pickARModel,
                          child: const Text("Upload .glb"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Submit Button ---
                  CustomElevatedButton(
                    text: isEdit ? "Update Product" : "Create Product",
                    onPressed: () => _submit(context, state),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
