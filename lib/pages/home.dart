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
  List<Post> _posts = [];
  List<Post> searchPosts = [];
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: [
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
                      itemCount: searchPosts.isNotEmpty
                          ? searchPosts.length
                          : _posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        searchPosts
                            .sort((a, b) => a.title!.compareTo(b.title!));
                        _posts.sort((a, b) => a.title!.compareTo(b.title!));

                        final data = searchPosts.isNotEmpty
                            ? searchPosts[index]
                            : _posts[index];

                        return Card(
                          child: ListTile(
                            title: Text(data.title ?? ''),
                            subtitle: Text(data.id ?? ''),
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
                                              controller: _descriptionController
                                                ..text = data.description ?? '',
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
                                              _updatedataState(
                                                  data.id.toString(), index);
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
                                  onTap: () => _deletedata(data.id.toString(), index),
                                ),
                              ],
                            ),
                          ),
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
