import 'package:iconfont_convert/src/iconfont_data.dart';
import 'package:iconfont_convert/src/utils.dart';

class IconTemplate {
  static String build(String className, IconFontData data) {
    var itemContent = data.glyphs
        .map((e) => _buildItem(e, data.fontPackage ?? ""))
        .join("\n");
    final previewIconContent =
        data.glyphs.map((e) => _buildPreviewIcon(e, className)).join("\n");

    var fontPackageContent = (data.fontPackage ?? "").isNotEmpty
        ? "\n  static const String _package = '${data.fontPackage}';"
        : "";

    String contents = '''
//  This file is automatically generated. DO NOT EDIT, all your changes would be lost.
//  https://pub.dartlang.org/packages/iconfont_convert

import 'package:flutter/material.dart';

class $className {
  static const String _family = '${data.fontFamily}';$fontPackageContent
  
  $className._();
  
$itemContent
}

class _PreviewIcon {
  const _PreviewIcon(this.icon, this.name, this.propName);

  final IconData icon;
  final String name;
  final String propName;
}

class ${className}Preview extends StatelessWidget {
  const ${className}Preview({Key? key}) : super(key: key);

  static const iconList = <_PreviewIcon>[
$previewIconContent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: SingleChildScrollView(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          children: iconList.map((e) {
            return InkWell(
              onTap: () {
                //
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Icon(e.icon),
                  ),
                  Text(e.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                  Text(e.propName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
''';

    return contents;
  }

  static String _buildItem(IconFontGlyph glyphs, String fontPackage) {
    String iconName = Utils.snake("${glyphs.fontClass}");
    String unicode = glyphs.unicode ?? "";
    String comment = "";
    String packageName = "";
    if (glyphs.name != null && glyphs.name != "") {
      comment = " // ${glyphs.name}";
    }

    if (fontPackage.isNotEmpty) {
      packageName = ", fontPackage: _package";
    }

    return '''  static const IconData $iconName = IconData(0x$unicode, fontFamily: _family$packageName);$comment''';
  }

  static String _buildPreviewIcon(IconFontGlyph glyphs, String iconClass) {
    String iconName = Utils.snake("${glyphs.fontClass}");

    return '''    _PreviewIcon($iconClass.$iconName, "$iconName", "${glyphs.name}"),''';
  }
}
