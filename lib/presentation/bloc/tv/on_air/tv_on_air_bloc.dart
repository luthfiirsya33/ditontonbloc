import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_on_air_event.dart';
part 'tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState> {
  final GetNowPlayingTv getOnAirTv;

  TvOnAirBloc(
    this.getOnAirTv,
  ) : super(TvOnAirEmpty()) {
    on<TvOnAirGetEvent>((event, emit) async {
      emit(TvOnAirLoading());
      final result = await getOnAirTv.execute();
      result.fold(
        (failure) {
          emit(TvOnAirError(failure.message));
        },
        (data) {
          emit(TvOnAirLoaded(data));
        },
      );
    });
  }
}