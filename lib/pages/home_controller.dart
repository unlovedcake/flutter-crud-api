part of 'home.dart';

extension ExtHome on _HomeState {

  
  void _loadPosts(int page) async {
           _isLoading = false;
    final posts = await PostService.getPosts(page);

    
    if(posts.isEmpty){
      setState(() {
          isNoMoreData.value = true;
     print('data: ${posts}');
      });

     return;
}
    setState(() {

       _posts.addAll(posts);
      _isLoading = true;
  
    });
  }

  void _updatedataState(String index, int indx) async {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    final posts = Item(
        id: index,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    final postsUpdate = await PostService.update(posts);

      Navigator.pop(context);
    setState(() {
      _posts[indx] = postsUpdate;
    });
  }

  

  Future<Item> _adddata() async {

    if (!_canAdd) {
      throw Exception('Cannot increment while already computing!');
    }



      _completer = Completer<Item>();

      final data = Item(
        id: '123',
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    
    final newdata = await PostService.create(data);
      Navigator.pop(context);
    setState(() {
     
      _posts.add(newdata);
      _titleController.clear();
      _descriptionController.clear();
       
    });

     return _completer!.future;
  }

  void _deletedata(String id,int index) async {
    //final posts = _posts[index];
    
    await PostService.delete(id);
    setState(() {
       _posts.removeAt(index);
    });
  }

  void _searchFilter(String enteredKeyword) async {
    if (enteredKeyword.isEmpty) {
      searchPosts = [];
      print(searchPosts);
    } else {
      searchPosts = _posts
          .where((element) => element.title!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {});
  }
}
