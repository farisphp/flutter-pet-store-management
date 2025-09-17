import 'package:flutter/material.dart';
import 'package:petstore/domain/entities/pet.dart';

class PetDialog extends StatefulWidget {
  final Pet? pet;
  final Function(Pet) onSave;

  const PetDialog({
    super.key,
    this.pet,
    required this.onSave,
  });

  @override
  _PetDialogState createState() => _PetDialogState();
}

class _PetDialogState extends State<PetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _tagNameController = TextEditingController();
  final _tagIdController = TextEditingController();

  PetStatus _selectedStatus = PetStatus.available;
  List<String> _photoUrls = [];
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _selectedStatus = widget.pet!.status;
      _photoUrls = List.from(widget.pet!.photoUrls);
      _tags = List.from(widget.pet!.tags);

      if (widget.pet!.category != null) {
        _categoryNameController.text = widget.pet!.category!.name;
        _categoryIdController.text = widget.pet!.category!.id.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pet == null ? 'Add New Pet' : 'Edit Pet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Pet Name *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.pets),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a pet name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      DropdownButtonFormField<PetStatus>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: PetStatus.values.map((PetStatus status) {
                          return DropdownMenuItem<PetStatus>(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getStatusColor(status),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status.value.toUpperCase()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (PetStatus? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Section
                      Text(
                        'Category (Optional)',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _categoryIdController,
                              decoration: const InputDecoration(
                                labelText: 'Category ID',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _categoryNameController,
                              decoration: const InputDecoration(
                                labelText: 'Category Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Photo URLs Section
                      Text(
                        'Photo URLs',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _photoUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Photo URL',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.photo),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              if (_photoUrlController.text.trim().isNotEmpty) {
                                setState(() {
                                  _photoUrls
                                      .add(_photoUrlController.text.trim());
                                  _photoUrlController.clear();
                                });
                              }
                            },
                            tooltip: 'Add Photo URL',
                          ),
                        ],
                      ),

                      if (_photoUrls.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _photoUrls
                              .map((url) => Chip(
                                    avatar: CircleAvatar(
                                        backgroundImage: NetworkImage(url)),
                                    label: Text(
                                      url.length > 30
                                          ? '${url.substring(0, 30)}...'
                                          : url,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    deleteIcon:
                                        const Icon(Icons.close, size: 18),
                                    onDeleted: () {
                                      setState(() {
                                        _photoUrls.remove(url);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Tags Section
                      Text(
                        'Tags',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tagIdController,
                              decoration: const InputDecoration(
                                labelText: 'Tag ID',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _tagNameController,
                              decoration: const InputDecoration(
                                labelText: 'Tag Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.local_offer),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              if (_tagIdController.text.trim().isNotEmpty &&
                                  _tagNameController.text.trim().isNotEmpty) {
                                final id =
                                    int.tryParse(_tagIdController.text.trim());
                                if (id != null) {
                                  setState(() {
                                    _tags.add(Tag(
                                      id: id,
                                      name: _tagNameController.text.trim(),
                                    ));
                                    _tagIdController.clear();
                                    _tagNameController.clear();
                                  });
                                }
                              }
                            },
                            tooltip: 'Add Tag',
                          ),
                        ],
                      ),

                      if (_tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _tags
                              .map((tag) => Chip(
                                    label: Text('${tag.name} (${tag.id})'),
                                    deleteIcon:
                                        const Icon(Icons.close, size: 18),
                                    onDeleted: () {
                                      setState(() {
                                        _tags.remove(tag);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _savePet,
                    child:
                        Text(widget.pet == null ? 'Create Pet' : 'Update Pet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(PetStatus status) {
    switch (status) {
      case PetStatus.available:
        return Colors.green;
      case PetStatus.pending:
        return Colors.orange;
      case PetStatus.sold:
        return Colors.red;
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      Category? category;
      if (_categoryIdController.text.trim().isNotEmpty &&
          _categoryNameController.text.trim().isNotEmpty) {
        final categoryId = int.tryParse(_categoryIdController.text.trim());
        if (categoryId != null) {
          category = Category(
            id: categoryId,
            name: _categoryNameController.text.trim(),
          );
        }
      }

      final pet = Pet(
        id: widget.pet?.id,
        name: _nameController.text.trim(),
        status: _selectedStatus,
        photoUrls: _photoUrls,
        category: category,
        tags: _tags,
      );

      widget.onSave(pet);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryNameController.dispose();
    _categoryIdController.dispose();
    _photoUrlController.dispose();
    _tagNameController.dispose();
    _tagIdController.dispose();
    super.dispose();
  }
}
