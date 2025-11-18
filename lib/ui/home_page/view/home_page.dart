import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tasks/core/theme/app_theme.dart';
import 'package:tasks/ui/home_page/view/widget/add_to_do_dialog.dart';
import 'package:tasks/ui/home_page/view/widget/no_to_do.dart';
import 'package:tasks/ui/home_page/view/widget/to_do_view.dart';
import 'package:tasks/ui/home_page/view_model/home_page_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: vrc(context).background300,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: vrc(context).background200,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(
                color: vrc(context).textColor200,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: _TodoBody(title: title),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: fxc(context).brandColor,
            shape: CircleBorder(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AddToDoDialog(),
              );
            },
            tooltip: 'Add Todo',
            child: const Icon(Icons.add_rounded, size: 24),
          ),
        ),
        Visibility(
          visible: ref.watch(homePageViewModelProvider).isLoading,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _TodoBody extends ConsumerStatefulWidget {
  const _TodoBody({required this.title});
  final String title;

  @override
  ConsumerState<_TodoBody> createState() => _TodoBodyState();
}

class _TodoBodyState extends ConsumerState<_TodoBody> {
  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(homePageViewModelProvider);
    return todos.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      loading: () => SizedBox.shrink(),
      error: (e, _) => Center(child: Text('$e')),
      data: (items) => items.isEmpty
          ? NoToDo(title: widget.title)
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(homePageViewModelProvider.notifier).refresh();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    final metrics = notification.metrics;
                    if (metrics.pixels >= metrics.maxScrollExtent - 50) {
                      ref.read(homePageViewModelProvider.notifier).loadMore();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) => ToDoView(toDo: items[i]),
                  ),
                ),
              ),
            ),
    );
  }
}
