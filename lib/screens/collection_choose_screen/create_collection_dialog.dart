import 'package:cats/blocs/collection_chooser_bloc/collection_choose_bloc.dart';
import 'package:cats/blocs/favourites_bloc/favourites_bloc.dart';
import 'package:cats/components/animated_button.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateCollectionDialog extends StatelessWidget {
  CreateCollectionDialog( {Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: BlocProvider.value(
        value: Injector.appInstance.get<FavouritesBloc>(),
        child: BlocListener<FavouritesBloc, FavouritesState>(
          listener: (context, state) {
            print(state.runtimeType);
            if (state is CollectionAlreadyExists) {
              showTopSnackBar(context, _createTopSnackBar(),leftPadding: 100,rightPadding: 100);
            }
            if (state is CollectionCreated) {
              Navigator.pop(context);
            }
          },
          child: GestureDetector(
            onTap: () =>
                FocusManager.instance.primaryFocus?.unfocus(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                color: MyColors.grey(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "New Collection",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CupertinoTextField(
                      controller: _textEditingController,
                      cursorColor: MyColors.grey(130),
                      style: TextStyle(color: MyColors.grey(200)),
                      decoration: BoxDecoration(
                          color: MyColors.grey(50),
                          borderRadius: BorderRadius.circular(10)),
                      onSubmitted: (text) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AnimatedButton(
                          onTap: () => Navigator.of(context).pop(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 90,
                              height: 45,
                              color: Colors.grey,
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center)),
                            ),
                          ),
                        ),
                        BlocBuilder<CollectionChooseBloc, CollectionChooseState>(
                          builder: (context, state) {
                            return AnimatedButton(
                              onTap: () => _tryCreateNewCollection(context,
                                  _textEditingController.value.text),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 90,
                                  height: 45,
                                  color: Colors.red,
                                  child: Center(
                                      child: state is CreatingCollection
                                          ? const CupertinoActivityIndicator()
                                          : const Text("Create",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center)),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _tryCreateNewCollection(BuildContext context,String text) {
    text = text.trim();
    if (text != "") {
      context.read<FavouritesBloc>().add(CreateCollection(text));
    }
  }

  Widget _createTopSnackBar() {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.red,
          child: const Text(
            "Collection with this name already exists. Try using another name.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
