import 'package:shadcn_flutter/shadcn_flutter.dart';

class PopoverExample1 extends StatelessWidget {
  const PopoverExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        showPopover(
          context: context,
          alignment: Alignment.topCenter,
          builder: (context) {
            return SurfaceCard(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Dimensions').large().medium(),
                    const Text('Set the dimensions for the layer.').muted(),
                    Form(
                      controller: FormController(),
                      child: const FormTableLayout(
                        rows: [
                          FormField<double>(
                            key: FormKey(#width),
                            label: Text('Width'),
                            child: TextField(
                              initialValue: '100%',
                            ),
                          ),
                          FormField<double>(
                            key: FormKey(#maxWidth),
                            label: Text('Max. Width'),
                            child: TextField(
                              initialValue: '300px',
                            ),
                          ),
                          FormField<double>(
                            key: FormKey(#height),
                            label: Text('Height'),
                            child: TextField(
                              initialValue: '25px',
                            ),
                          ),
                          FormField<double>(
                            key: FormKey(#maxHeight),
                            label: Text('Max. Height'),
                            child: TextField(
                              initialValue: 'none',
                            ),
                          ),
                        ],
                        spacing: 8,
                      ),
                    ).withPadding(vertical: 16),
                  ],
                ),
              ),
            ).withPadding(vertical: 8);
          },
        );
      },
      child: const Text('Open popover'),
    );
  }
}
