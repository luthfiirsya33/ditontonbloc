import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:ditonton/presentation/bloc/tv/on_air/tv_on_air_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_air_tv_bloc_test.mocks.dart';

@GenerateMocks([TvOnAirBloc,GetNowPlayingTv])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late TvOnAirBloc tvOnAirBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    tvOnAirBloc = TvOnAirBloc(mockGetNowPlayingTv);
  });

  final tvList = <Tv>[];

  test("initial state should be empty", () {
    expect(tvOnAirBloc.state, TvOnAirEmpty());
  });

  group('On Air Tv BLoC Test', () {
    blocTest<TvOnAirBloc, TvOnAirState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(tvList));
        return tvOnAirBloc;
      },
      act: (bloc) => bloc.add(TvOnAirGetEvent()),
      expect: () => [TvOnAirLoading(), TvOnAirLoaded(tvList)],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      },
    );

    blocTest<TvOnAirBloc, TvOnAirState>(
      'Should emit [Loading, Error] when get now playing is unsuccessful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvOnAirBloc;
      },
      act: (bloc) => bloc.add(TvOnAirGetEvent()),
      expect: () => [
        TvOnAirLoading(),
        const TvOnAirError('Server Failure')
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      },
    );
    },
  );
}