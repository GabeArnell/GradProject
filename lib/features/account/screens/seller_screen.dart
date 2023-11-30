import 'package:flutter/material.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/widgets/below_app_bar.dart';
import 'package:thrift_exchange/features/account/widgets/custom_sub_banner.dart';
import 'package:thrift_exchange/features/account/widgets/orders.dart';
import 'package:thrift_exchange/features/account/widgets/review_box.dart';
import 'package:thrift_exchange/features/account/widgets/top_buttons.dart';
import 'package:thrift_exchange/features/chat/screens/chat_home_page.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';

import '../../../models/review.dart';
import '../services/review_service.dart';

class SellerScreen extends StatefulWidget {
    final String email;
    final String name;
    final String image;
    final double averageStars;

  const SellerScreen({super.key, required this.email, required this.name, required this.image, required this.averageStars,});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  ReviewService reviewService = ReviewService();

  List<Review> reviews = [];

  @override
  void initState(){
    super.initState();
    getReviews();
  }

  void getReviews()async{
    reviews = await reviewService.getReviews(context, widget.email);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 251, 188, 0).withOpacity(0.4),
                      BlendMode.srcOver),
                  child: Image.asset(
                    'assets/images/thrift_exchange_logo.jpg',
                    width: 55,
                    height: 95,
                    //color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ChatHomePage.routeName);
                          //ChatHomePage();
                        },
                        icon: Icon(
                          Icons.message_outlined,
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CustomSubBanner(title: 'Seller Profile: ${widget.email}',),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                  maxRadius: 50, 
                ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    Text(
                      'Name : ${widget.name}',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),   
                    ),  
                    const SizedBox(height: 15),
      
                    Text(
                      'Average Stars : ${widget.averageStars.roundToDouble()}',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),   
                    ),
                  ],
                ),    
            ],),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                'Review Seller',
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ))
              ,
              Container(
                constraints: BoxConstraints(minWidth: 100,maxWidth: 500),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'They were a great communicator!.',
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black38,
                        )),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black38,
                        ))),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter your Message';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) async {
                      if (value.isNotEmpty) {
                         String response = await reviewService.addReview(
                            context: context,
                            email: widget.email,
                            content: value);
              
                        getReviews();
                        setState(() {
                          
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
      
          
          SizedBox(
            child: Column(
              children: [
                Text(
                  'Previous Reviews',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
                if (reviews.isNotEmpty)
                SingleChildScrollView(
                  child: SizedBox(
                    height: 390,
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        
                        return ReviewBox( deleteCallback: getReviews,writer: reviews[index].writer, subject: reviews[index].subject, content: reviews[index].content, timestamp: reviews[index].timestamp);
                      },
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
