import 'package:flutter/material.dart';

class NBLockedAlertFER extends StatelessWidget {
  final String inf;
  const NBLockedAlertFER({super.key, required this.inf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: Container(
          width: 300,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF060F2B),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(inf, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF46F180),
                  ),
                  alignment: Alignment.center,
                  child: Text('OK', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
