import 'package:flutter/material.dart';
import 'package:dio_stage_host_selector/repository/proxy_repository.dart';
import 'package:dio_stage_host_selector/repository/stage_repository.dart';
import 'package:dio_stage_host_selector/ui/input_dialog.dart';

class StageHostSelectorDialog extends StatelessWidget {
  final StageRepository? stageRepository;
  final ProxyRepository? proxyRepository;

  StageHostSelectorDialog({
    Key? key,
    this.stageRepository,
    this.proxyRepository,
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
            stream: stageRepository!.selectedUrlStream,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              final selectedUrl = snapshot.data;

              return StreamBuilder(
                stream: stageRepository!.suggestedUrlsStream,
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
                                stageRepository!.selectUrl(url);
                              } else {
                                stageRepository!.selectUrl(null);
                              }
                            },
                            onDeleted: () =>
                                stageRepository!.removeSuggestedUrl(url),
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
          Text('Proxy', style: theme.textTheme.headline6),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: proxyRepository!.selectedProxyStream,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              final selectedProxy = snapshot.data;

              return StreamBuilder(
                stream: proxyRepository!.suggestedProxysStream,
                initialData: const <String>{},
                builder: (BuildContext context,
                    AsyncSnapshot<Set<String>> snapshot) {
                  return Wrap(
                    spacing: 8,
                    children: <Widget>[
                      for (String proxy in snapshot.data!)
                        GestureDetector(
                          onLongPress: () =>
                              _showAddProxyDialog(context, initialText: proxy),
                          child: InputChip(
                            label: Text(
                              proxy,
                              overflow: TextOverflow.clip,
                            ),
                            selected: proxy == selectedProxy,
                            onSelected: (bool value) {
                              if (value) {
                                proxyRepository!.selectProxy(proxy);
                              } else {
                                proxyRepository!.selectProxy(null);
                              }
                            },
                            onDeleted: () => {},
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
      ),
    );
  }

  void _showAddUrlDialog(BuildContext context, {String? initialText}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => InputDialog(
        hintText: 'Input stage URL',
        onSubmit: (url) => stageRepository!.addSuggestedUrl(url),
        initialText: initialText,
      ),
    );
  }

  void _showAddProxyDialog(BuildContext context, {String? initialText}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => InputDialog(
        hintText: 'Input proxy address',
        onSubmit: (proxy) => proxyRepository!.addSuggestedProxy(proxy),
        initialText: initialText,
      ),
    );
  }
}
