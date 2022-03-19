import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio_stage_host_selector/ui/input_dialog.dart';

import '../repository/base_repository.dart';

class StageHostSelectorDialog extends StatelessWidget {
  final Repository stageRepository;
  final Repository proxyRepository;

  StageHostSelectorDialog({
    Key? key,
    required this.stageRepository,
    required this.proxyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      shape: theme.bottomSheetTheme.shape,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text('Stage URL', style: theme.textTheme.headline6),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: stageRepository.currentValueStream,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              final selectedUrl = snapshot.data;

              return StreamBuilder(
                stream: stageRepository.suggestedValuesStream,
                initialData: const <String>{},
                builder: (BuildContext context,
                    AsyncSnapshot<Set<String>> snapshot) {
                  return Wrap(
                    spacing: 8,
                    children: <Widget>[
                      for (String url in snapshot.data!)
                        GestureDetector(
                          onLongPress: () =>
                              _showAddUrlDialog(context, initialText: url),
                          child: InputChip(
                            label: Text(
                              url,
                              overflow: TextOverflow.clip,
                            ),
                            selected: url == selectedUrl,
                            onSelected: (bool value) {
                              if (value) {
                                stageRepository.setCurrentValue(url);
                              } else {
                                stageRepository.setCurrentValue(null);
                              }
                            },
                            onDeleted: () =>
                                stageRepository.removeSuggestedValue(url),
                          ),
                        ),
                      ActionChip(
                        avatar: Icon(Icons.add),
                        label: Text('ADD'),
                        onPressed: () => _showAddUrlDialog(context),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 8),
          if (!kIsWeb) ...[
            Text('Proxy', style: theme.textTheme.headline6),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: proxyRepository.currentValueStream,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                final selectedProxy = snapshot.data;

                return StreamBuilder(
                  stream: proxyRepository.suggestedValuesStream,
                  initialData: const <String>{},
                  builder: (BuildContext context,
                      AsyncSnapshot<Set<String>> snapshot) {
                    return Wrap(
                      spacing: 8,
                      children: <Widget>[
                        for (String proxy in snapshot.data!)
                          GestureDetector(
                            onLongPress: () => _showAddProxyDialog(context,
                                initialText: proxy),
                            child: InputChip(
                              label: Text(
                                proxy,
                                overflow: TextOverflow.clip,
                              ),
                              selected: proxy == selectedProxy,
                              onSelected: (bool value) {
                                if (value) {
                                  proxyRepository.setCurrentValue(proxy);
                                } else {
                                  proxyRepository.setCurrentValue(null);
                                }
                              },
                              onDeleted: () =>
                                  proxyRepository.removeSuggestedValue(proxy),
                            ),
                          ),
                        ActionChip(
                          avatar: Icon(Icons.add),
                          label: Text('ADD'),
                          onPressed: () => _showAddProxyDialog(context),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showAddUrlDialog(BuildContext context, {String? initialText}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => InputDialog(
        hintText: 'Input stage URL',
        onSubmit: (url) => stageRepository.addSuggestedValue(url),
        initialText: initialText ?? r'https://',
      ),
    );
  }

  void _showAddProxyDialog(BuildContext context, {String? initialText}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => InputDialog(
        hintText: 'Input proxy address',
        onSubmit: (proxy) => proxyRepository.addSuggestedValue(proxy),
        initialText: initialText,
      ),
    );
  }
}
