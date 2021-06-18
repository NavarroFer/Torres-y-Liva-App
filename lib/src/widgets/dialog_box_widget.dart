import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, textBtn1, textBtn2, obs;
  final Image img;
  final IconData icon;
  final bool alert;
  final double cant;
  const CustomDialogBox(
      {Key key,
      this.title = '',
      this.descriptions = '',
      this.textBtn1 = '',
      this.textBtn2 = '',
      this.cant,
      this.obs,
      this.icon,
      this.alert = false,
      this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  static final double padding = 20;
  static final double avatarRadius = 20;

  bool primeraVez = true;

  TextEditingController _observacionesController = TextEditingController();
  TextEditingController _cantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (primeraVez) {
      _cantController.text = widget?.cant?.toString() ?? '';
      _observacionesController.text = widget?.obs?.toString() ?? '';
      primeraVez = false;
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: widget.alert ? contentBoxAlert(context) : contentBox(context),
    );
  }

  Widget contentBoxAlert(context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title ?? '',
                style: TextStyle(
                    fontSize: size.width * size.aspectRatio * 0.15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                widget.descriptions ?? '',
                style: TextStyle(
                  fontSize: size.width * size.aspectRatio * 0.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        widget.textBtn1,
                        style: TextStyle(
                            fontSize: size.width * size.aspectRatio * 0.1,
                            fontWeight: FontWeight.bold),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        widget.textBtn2,
                        style: TextStyle(
                            fontSize: size.width * size.aspectRatio * 0.1,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            left: padding,
            right: padding,
            // top: 100,
            child: Icon(
              widget.icon,
              color: Colors.red,
              size: size.width * size.aspectRatio * 0.3,
            )),
      ],
    );
  }

  Widget contentBox(context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title ?? '',
                style: TextStyle(
                    fontSize: size.width * size.aspectRatio * 0.15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions ?? '',
                style: TextStyle(
                  fontSize: size.width * size.aspectRatio * 0.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              TextField(
                controller: _observacionesController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.text,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height * 0.05),
                  hintText: 'Observaciones',
                  labelText: 'Observaciones',
                ),
              ),
              TextField(
                controller: _cantController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.numeric,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height * 0.05),
                  hintText: 'Cantidad',
                  labelText: 'Cantidad',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.textBtn1,
                        style: TextStyle(
                          fontSize: size.width * size.aspectRatio * 0.1,
                        ),
                      )),
                  FlatButton(
                      onPressed: () {
                        final cant = double.tryParse(_cantController.text);
                        if (cant != null && cant > 0) {
                          //Agregar item a pedido
                          final res = [cant, _observacionesController.text];
                          Navigator.of(context).pop(res);
                        }
                      },
                      child: Text(
                        widget.textBtn2,
                        style: TextStyle(
                          fontSize: size.width * size.aspectRatio * 0.1,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: widget.img),
          ),
        ),
      ],
    );
  }
}
