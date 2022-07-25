const String homePage = '/';
const String addClientPage = '/add-client';

enum Page { home, addClient }

class PageConfiguration {
  final String key;
  final String path;
  final Page uiPage;
  // PageAction? currentPageAction;

  PageConfiguration({
    required this.key,
    required this.path,
    required this.uiPage,
    // this.currentPageAction,
  });

  PageConfiguration addClientPageConfig = PageConfiguration(
    key: 'AddClient',
    path: addClientPage,
    uiPage: Page.addClient,
    // currentPageAction: null,
  );
}
