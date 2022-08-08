import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/view/profile/item_profile_cat.dart';
import 'package:flutter/material.dart';

class DialogProfileCategory extends StatefulWidget {
  final Function function;

  DialogProfileCategory(this.function);

  @override
  _DialogProfileCategoryState createState() => _DialogProfileCategoryState();
}

class _DialogProfileCategoryState extends State<DialogProfileCategory> {
  @override
  void initState() {
    getProfileCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: colorPrimary,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                color: colorPrimaryDark,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Choose Category',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 0.65,
                ),
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                children: mList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ItemProfileCat> mList = [];

  void getProfileCategory() {
    ApiService().getProfileCategoryList().then((value) {
      mList = List.generate(
        value.data.length,
        (index) => ItemProfileCat(
          value.data[index],
          (data) {
            widget.function(data);
          },
        ),
      );
      setState(() {});
    });
  }
}
