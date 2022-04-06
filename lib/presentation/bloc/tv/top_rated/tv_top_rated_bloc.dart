import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_top_rated_event.dart';
part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTv getTopRatedTv;

  TvTopRatedBloc(
    this.getTopRatedTv,
  ) : super(TvTopRatedEmpty()) {
    on<TvTopRatedGetEvent>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await getTopRatedTv.execute();
      result.fold(
        (failure) {
          emit(TvTopRatedError(failure.message));
        },
        (data) {
          emit(TvTopRatedLoaded(data));
        },
      );
    });
  }
}