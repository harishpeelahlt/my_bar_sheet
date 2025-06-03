import 'package:flutter/material.dart';
import 'package:mybarsheet/core/constants/appColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final categories = ['Whiskey', 'Champagne', 'Wine', 'Beer'];

  final products = [
    {
      'name': "JACKSON'S",
      'type': 'Whiskey',
      'price': 56.00,
      'image': 'assets/images/avif/whisky.avif',
    },
    {
      'name': "mong'S",
      'type': 'Whiskey',
      'price': 56.00,
      'image': 'assets/images/avif/liquorr.avif',
    },
    {
      'name': "BOMBAY",
      'type': 'Champagne',
      'price': 75.00,
      'image': 'assets/images/avif/liquorr.avif',
    },
  ];

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategory = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((p) => p['type'] == categories[_selectedCategory])
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 0),
              child: Text(
                'Hi, Jagadeesh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
            ),
            const SizedBox(height: 20),

            CategorySelector(
              categories: categories,
              selectedIndex: _selectedCategory,
              onCategoryTap: _onCategoryTap,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Widget for horizontal category selector pills
class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final void Function(int) onCategoryTap;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent
                    : const Color(0xFF2D1E2F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : const Color(0xFFF4F1DE),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1; // Start with 1 quantity
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void increment() {
    setState(() {
      quantity++;
      _controller.text = quantity.toString();
    });
  }

  void decrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        _controller.text = quantity.toString();
      });
    }
  }

  void onManualChange(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      _controller.text = quantity.toString();
    } else {
      setState(() {
        quantity = parsed;
      });
    }
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void onSave() {
    FocusScope.of(context).unfocus(); // Remove cursor/keyboard on save

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['name']} quantity saved: $quantity'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Add actual save logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16, bottom: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E2F),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rounded top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Image.asset(
              product['image'] as String,
              height: 440,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFF4F1DE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['type'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price + taxes text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${((product['price'] ?? 0) as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFF4F1DE),
                          ),
                        ),
                        Text(
                          'inc. all taxes',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),

                    // ALWAYS show quantity controls
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: decrement,
                            child: const Icon(
                              Icons.remove,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 40,
                            height: 28,
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              onChanged: onManualChange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: increment,
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 32,
                    width: 80,
                    child: ElevatedButton(
                      onPressed: quantity > 0 ? onSave : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 5,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


