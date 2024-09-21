import 'dart:async';

import 'package:crud_api/fade_animate_dialog.dart';
import 'package:crud_api/models/post_model.dart';
import 'package:crud_api/service/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> _posts = [];
  List<Item> searchPosts = [];
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ValueNotifier<bool> isNoMoreData = ValueNotifier(false);

  int page = 2;

  Completer<Item>? _completer;
  bool get _canAdd => _completer == null || _completer!.isCompleted;

  ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts(page);

    _scrollController.addListener(() {
      if (!isNoMoreData.value) {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            _isLoading) {
          page++;
          _loadPosts(page);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void showFadeAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FadeAlertDialog();
      },
    );
  }

  String formatDateTime(String dateTime) {
    // Parse the date-time string to a DateTime object
    DateTime parsedDateTime = DateTime.parse(dateTime);

    // Format the date to 'MMM dd, yyyy' (e.g., Aug 15, 2024)
    String formattedDate =
        DateFormat('MMM dd, yyyy - hh:mm a').format(parsedDateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    print('Reload Home');
    print('May var:' + const String.fromEnvironment('MY_VAR'));
    print(const String.fromEnvironment('MY_OTHER_VAR'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          ElevatedButton(
              child: Text('Show Map'),
              onPressed: () {
                Navigator.pushNamed(context, '/googlemap');
                //showFadeAlertDialog(context);
              }),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Settings')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/todo');
              },
              child: Text('Todo')),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Icon(Icons.add),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Add Post'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter title',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter Description',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          _adddata();
                        },
                        child: Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,

                  enabledBorder:
                      InputBorder.none, // Removes enabled state border
                  focusedBorder:
                      InputBorder.none, // Removes focused state border
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(strokeAlign: 8),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (val) {
                _searchFilter(val);

                print(val);
              },
            ),
            SizedBox(
              height: 20,
            ),
            searchPosts.isEmpty && _searchController.text.isNotEmpty
                ? Center(child: Text('No search found.'))
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: searchPosts.isNotEmpty
                          ? searchPosts.length
                          : _posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        searchPosts.sort(
                            (b, a) => a.createdAt!.compareTo(b.createdAt!));
                        _posts.sort(
                            (b, a) => a.createdAt!.compareTo(b.createdAt!));

                        final data = searchPosts.isNotEmpty
                            ? searchPosts[index]
                            : _posts[index];

                        print('Index: ${index} Posts: ${_posts.length}');

                        if (index == _posts.length - 1) {
                          return isNoMoreData.value
                              ? Text('No More Data')
                              : _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text(data.title ?? ''),
                                subtitle: Text(
                                    formatDateTime(data.createdAt.toString()) ??
                                        ''),
                                trailing: Column(
                                  children: [
                                    InkWell(
                                      child: Icon(Icons.edit),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Update Post'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: _titleController
                                                    ..text = data.title ?? '',
                                                  decoration: InputDecoration(
                                                    labelText: 'Title',
                                                    hintText: 'Enter title',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      _descriptionController
                                                        ..text =
                                                            data.description ??
                                                                '',
                                                  decoration: InputDecoration(
                                                    labelText: 'Description',
                                                    hintText:
                                                        'Enter Description',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  _updatedataState(
                                                      data.id.toString(),
                                                      index);
                                                },
                                                child: Text('Update'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    InkWell(
                                      child: Icon(Icons.delete),
                                      onTap: () => _deletedata(
                                          data.id.toString(), index),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //    ValueListenableBuilder<bool>(
                            //   valueListenable: isNoMoreData,
                            //   builder: (context, value, child) {
                            //     return value ? Center(child: Text('No more data')) : SizedBox.shrink();
                            //   },
                            // )
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class FadeInDialog extends StatelessWidget {
  final Widget child;

  FadeInDialog({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: child,
    );
  }
}
