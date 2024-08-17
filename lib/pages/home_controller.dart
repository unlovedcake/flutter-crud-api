part of 'home.dart';

extension ExtHome on _HomeState {

  
  void _loadPosts(int page) async {
           _isLoading = true;
    final posts = await PostService.getPosts(page);
    if(posts.isEmpty){
  isNoMoreData.value = true;
     print('data: ${posts}');
     return;
}
    setState(() {

       _posts.addAll(posts);
      _isLoading = false;
  
    });
  }

  void _updatedataState(String index, int indx) async {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    final posts = Post(
        id: index,
        title: _titleController.text,
        description: _descriptionController.text,
        completed: true,
        created_at: " ",
        updated_at: formattedDate);

    final postsUpdate = await PostService.update(posts);

      Navigator.pop(context);
    setState(() {
      _posts[indx] = postsUpdate;
    });
  }

  void _adddata() async {
    final data = Post(
      title: _titleController.text,
      description: _descriptionController.text,
      completed: false,
    );
    final newdata = await PostService.create(data);
      Navigator.pop(context);
    setState(() {
      _posts.add(newdata);
      _titleController.clear();
      _descriptionController.clear();
    });
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
