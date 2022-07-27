abstract class INavigationService {
  Future<void> toNamed(String path, {Object? arguments});
  Future<void> offAndNamed(String path, {Object? arguments});
  Future<void> pop();
}
