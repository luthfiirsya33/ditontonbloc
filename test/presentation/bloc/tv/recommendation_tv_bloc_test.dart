import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/recommendation/tv_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_tv_bloc_test.mocks.dart';

@GenerateMocks([TvRecommendationBloc,GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTvRecommendation;
  late TvRecommendationBloc tvRecommendationBloc;

  setUp(() {
    mockGetTvRecommendation = MockGetTvRecommendations();
    tvRecommendationBloc = TvRecommendationBloc(
      getTvRecommendations: mockGetTvRecommendation,
    );
  });

  test("initial state should be empty", () {
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  const tvId = 1;
  final tvList = <Tv>[];

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendation.execute(tvId))
          .thenAnswer((_) async => Right(tvList));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(const GetTvRecommendationEvent(tvId)),
    expect: () =>
        [TvRecommendationLoading(), TvRecommendationLoaded(tvList)],
    verify: (bloc) {
      verify(mockGetTvRecommendation.execute(tvId));
    },
  );

  group('Recommendation Tv BLoC Test', () {
    blocTest<TvRecommendationBloc, TvRecommendationState>(
      'Should emit [Loading, Error] when get recommendation is unsuccessful',
      build: () {
        when(mockGetTvRecommendation.execute(tvId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvRecommendationBloc;
      },
      act: (bloc) => bloc.add(const GetTvRecommendationEvent(tvId)),
      expect: () => [
        TvRecommendationLoading(),
        const TvRecommendationError('Server Failure')
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendation.execute(tvId));
      },
    );
    },
  );
}