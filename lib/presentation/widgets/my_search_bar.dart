import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc_event.dart';

class MySearchBar extends StatelessWidget {
  MySearchBar({
    super.key,
  });

  final TextEditingController searchController = TextEditingController();

  void _handleSearch(BuildContext context, String query) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    debugPrint('Search query: $query');
    searchBloc.add(SearchButtonPressed(
      query: searchController.text,
      ll: '45.2671,19.8335',
      radius: 10000,
      limit: 10,
    ));
    Navigator.pushNamed(context, '/search_result_screen');
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF303133).withOpacity(0.15),
            offset: const Offset(0, 16),
            blurRadius: 30.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: const Color(0xFF303133).withOpacity(0.10),
            offset: const Offset(0, 0),
            blurRadius: 1.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                _handleSearch(context, searchController.text);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 26,
              )),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search Places',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                  height: 28.0 / 18.0,
                  color: Color(0xFF9E9E9E),
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (String query) {
                _handleSearch(context, query);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              searchController.clear();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
