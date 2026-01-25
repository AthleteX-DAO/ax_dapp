import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/loader.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopPredict extends StatefulWidget {
  const DesktopPredict({
    super.key,
  });

  @override
  State<DesktopPredict> createState() => _DesktopPredictState();
}

class _DesktopPredictState extends State<DesktopPredict> {
  Global global = Global();
  EthereumChain? _selectedChain;

  @override
  Widget build(BuildContext context) {
    context
        .read<TopNavigationBarBloc>()
        .add(const SelectButtonEvent(buttonName: 'predict'));
    context
        .read<BottomNavigationBarBloc>()
        .add(const SelectItemEvent(itemIndex: 0));
    return BlocBuilder<PredictPageBloc, PredictPageState>(
      builder: (context, state) {
        final bloc = context.read<PredictPageBloc>();
        global.predictions = state.filteredPredictions;
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc.add(
            const FetchPredictionInfoRequested(),
          );
        }
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isNarrow = constraints.maxWidth < 1100;
            final heroHeight = isNarrow ? 240.0 : 320.0;
            return Stack(
              children: [
                CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: constraints.maxWidth * 0.97,
                        child: const Divider(color: Colors.grey),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 80,
                        child: PredictionMarketsFilterDesktop(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: SizedBox(
                          height: heroHeight,
                          child: const PredictionHeroCarouselPlaceholder(),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isNarrow ? 12 : 0,
                      ),
                      sliver: PredictionMarketsSliverGrid(
                        predictions: state.filteredPredictions,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const Positioned.fill(
                    child: Center(child: Loader()),
                  ),
                if (state.status == BlocStatus.error)
                  const Positioned.fill(
                    child: Center(
                      child: PredictionLoadingStatus(
                        message: 'Unable to load markets, please refresh',
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
