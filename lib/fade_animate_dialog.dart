import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FadeAlertDialog extends StatefulWidget {
  @override
  _FadeAlertDialogState createState() => _FadeAlertDialogState();
}

class _FadeAlertDialogState extends State<FadeAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
        _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
        _animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: AlertDialog(
        title: Text('Title'),
        contentPadding: EdgeInsets.zero,  // Remove default padding
        content: Container(
    
  // Set custom width here
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is a custom width dialog.'),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                   
                  _animationController.reverse().then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class FadeAlertDialog extends StatefulWidget {
//   @override
//   _FadeAlertDialogState createState() => _FadeAlertDialogState();
// }

// class _FadeAlertDialogState extends State<FadeAlertDialog> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..forward();
//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

//     // Auto close dialog after 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       _animationController.reverse().then((_) {
//         Navigator.of(context).pop();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: FadeTransition(
//         opacity: _opacityAnimation,
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text('This is a fade-in and fade-out dialog'),
//           ),
//         ),
//       ),
//     );
//   }
// }