import 'package:flutter/material.dart';
import 'package:schoolmi/extensions/presenter.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/managers/home.dart';

class ConnectionErrorDialog extends StatelessWidget {

  final HomeManager homeManager;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Presenter presenter;

  ConnectionErrorDialog ( this.homeManager, { this.scaffoldKey, this.presenter } );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: BrandColors.blueGrey,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TitleLabel(
                title: Localization().getValue(Localization().errorUnexpectedShort),
              ),
              SizedBox(
                height: 8,
              ),
              RegularLabel(
                title: Localization().getValue(Localization().errorConnection),
              ),
              SizedBox(
                height: 8,
              ),
              RaisedButton(
                  child: homeManager.isLoading ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ) : RegularLabel(title: Localization().getValue(Localization().retry),
                    color: Colors.white,
                  ),
                  elevation: 0,
                  onPressed: () {
                    if (homeManager.isLoading) {
                      return;
                    }

                    homeManager.refreshData().then((result) {

                      if (result == InitializationResult.serverConnectionError) {
                        showSnackBar(
                          scaffoldKey: scaffoldKey,
                          isError: true,
                          message: Localization().getValue(Localization().stillNoConnection)
                        );
                      } else  {
                        Navigator.pop(context);

                        if (result == InitializationResult.noChannelAvailable) {
                          presenter.showChannelsIntro();
                        }

                      }
                    });
                  }
              )

            ],
          ),
        ),
      ),
    );
  }
}