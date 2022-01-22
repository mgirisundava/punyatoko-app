import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_model.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/theme.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);

  static const routeName = "edit-product";

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductModel(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final validator = _form.currentState.validate();
    if (!validator) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("An error occupied!"),
                  content: const Text(
                    "Something went wrong.",
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ]);
            });
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.pop(context);
      // }

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: kPunyatokoTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: kBlackColor,
          ),
        ),
        foregroundColor: kBlackColor,
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _initValues["title"],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please provide a value.";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              label: Text("Title"),
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = ProductModel(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: value,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues["price"],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a price.";
                              }
                              if (double.tryParse(value) == null) {
                                return "Please enter a valid number";
                              }
                              if (double.parse(value) <= 0) {
                                return "Please enter a number greater than zero.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text("Price"),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = ProductModel(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(value),
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues["description"],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a description.";
                              }
                              if (value.length < 10) {
                                return "Should be at least 10 characters long.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text("Description"),
                            ),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            focusNode: _descriptionFocusNode,
                            onSaved: (value) {
                              _editedProduct = ProductModel(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: value,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 16,
                                  right: 10,
                                ),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: _imageUrlController.text.isEmpty
                                    ? const Center(
                                        child: Text("Enter a URL"),
                                      )
                                    : SizedBox(
                                        child: Image(
                                          image: NetworkImage(
                                              _imageUrlController.text),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter an image URL.";
                                    }
                                    if (!value.startsWith("http") &&
                                        !value.startsWith("https")) {
                                      return "Please enter a valid URL.";
                                    }
                                    if (!value.endsWith(".png") &&
                                        !value.endsWith(".jpeg") &&
                                        !value.endsWith(".jpg")) {
                                      return "Please enter a valid image URL.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text("Image URL"),
                                  ),
                                  controller: _imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (_) {
                                    _saveForm();
                                  },
                                  onSaved: (value) {
                                    _editedProduct = ProductModel(
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      price: _editedProduct.price,
                                      imageUrl: value,
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
