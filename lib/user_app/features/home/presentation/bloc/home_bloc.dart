import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetSliderImagesUseCase _getSliderImagesUseCase;

  HomeBloc({required GetSliderImagesUseCase getSliderImagesUseCase})
    : _getSliderImagesUseCase = getSliderImagesUseCase,
      super(HomeInitial()) {
    on<LoadHomeData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    // Hum yahan sirf slider images fetch kar rahe hain.
    // Hum baqi data bhi isi tarah fetch kar sakte hain.
    await emit.forEach(
      _getSliderImagesUseCase(),
      onData: (result) => result.fold(
        (failure) => HomeFailure(message: failure.message),
        (sliderImages) => HomeLoaded(sliderImages: sliderImages),
      ),
      onError: (error, stackTrace) =>
          const HomeFailure(message: 'An error occurred.'),
    );
  }
}
