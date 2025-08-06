import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_btk/gemini_api.dart';
import 'package:flutter_application_btk/onerilerEkrani.dart';
import 'package:google_fonts/google_fonts.dart';

class SoruEkrani extends StatefulWidget {
  const SoruEkrani({super.key});

  @override
  State<SoruEkrani> createState() => _SoruEkraniState();
}

class _SoruEkraniState extends State<SoruEkrani> {
  int _currentStep = 0;
  final _formkeys = List.generate(3, (_) => GlobalKey<FormState>());
  final List<TextEditingController> _ilgiAlanlariController = [
    TextEditingController(),
  ];
  final List<bool> _completedSteps = List.generate(6, (_) => false);

  String alici = '';
  String neden = '';
  String yas = '';
  String cinsiyet = '';
  String butce = '';

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _ilgiAlanlariController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        _currentStep < 6) {
      _continueToNextStep();
    }
  }

  void _continueToNextStep() {
    if (_currentStep < 5) {
      if (_currentStep < 3) {
        if (_formkeys[_currentStep].currentState!.validate()) {
          setState(() {
            _completedSteps[_currentStep] = true;
            _currentStep++;
          });
          _setFocus();
        }
      } else {
        setState(() {
          _completedSteps[_currentStep] = true;
          _currentStep++;
        });
        _setFocus();
      }
    }
  }

  void _setFocus() {
    if (_currentStep < _focusNodes.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[_currentStep].requestFocus();
      });
    }
  }

  bool get _isFormValid {
    return alici.trim().isNotEmpty &&
        neden.trim().isNotEmpty &&
        yas.trim().isNotEmpty;
  }

  Future<void> _sendData() async {
    if (alici.trim().isEmpty) {
      _showErrorAndGoToStep(
        0,
        "Lütfen 'Kime hediye alıyorsunuz?' sorusunu cevaplayın!",
      );
      return;
    }

    if (neden.trim().isEmpty) {
      _showErrorAndGoToStep(
        1,
        "Lütfen 'Ne için alıyorsunuz?' sorusunu cevaplayın!",
      );
      return;
    }

    if (yas.trim().isEmpty) {
      _showErrorAndGoToStep(2, "Lütfen 'Kaç yaşında?' sorusunu cevaplayın!");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromARGB(255, 131, 106, 173),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Hediye önerileri hazırlanıyor...",
                    style: GoogleFonts.pangolin(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final ilgiAlanlari = _ilgiAlanlariController
          .map((e) => e.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final oneriler = await GeminiService.hediyeOnerisi(
        alici: alici,
        neden: neden,
        yas: yas,
        cinsiyet: cinsiyet,
        ilgiAlanlari: ilgiAlanlari,
        butce: butce,
      );

      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnerilerEkrani(oneriler: oneriler),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text("Bir hata oluştu: $e"),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showErrorAndGoToStep(int step, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.pangolin(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    setState(() {
      _currentStep = step;
    });
    _setFocus();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _currentStep < _focusNodes.length
          ? _focusNodes[_currentStep]
          : _focusNodes[0],
      onKey: _handleKeyPress,
      autofocus: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 195, 133, 163),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.live_help_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Soru Ekranı",
                style: GoogleFonts.pangolin(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Adım ${_currentStep + 1}/6",
                style: GoogleFonts.pangolin(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              color: const Color.fromARGB(255, 87, 144, 89),
              minHeight: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Stepper(
                  currentStep: _currentStep,
                  type: StepperType.vertical,
                  stepIconBuilder: (stepIndex, stepState) {
                    if (stepState == StepState.complete) {
                      return CircleAvatar(
                        backgroundColor: Colors.white60,
                        child: Icon(
                          Icons.check,
                          color: const Color.fromARGB(255, 116, 159, 117),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: const Color.fromARGB(
                          255,
                          195,
                          133,
                          163,
                        ),
                        child: Text(
                          "${stepIndex + 1}",
                          style: GoogleFonts.pangolin(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Row(
                      children: [
                        if (_currentStep < 5)
                          ElevatedButton(
                            onPressed: _continueToNextStep,
                            child: Text(
                              "Devam et (Enter)",
                              style: GoogleFonts.pangolin(
                                color: const Color.fromARGB(255, 114, 62, 137),
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentStep--;
                              });
                              _setFocus();
                            },
                            child: Text(
                              "Geri",
                              style: GoogleFonts.pangolin(
                                color: const Color.fromARGB(255, 204, 101, 101),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  onStepContinue: _continueToNextStep,
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                      _setFocus();
                    }
                  },
                  onStepTapped: (step) {
                    if (_currentStep < 3 &&
                        !_formkeys[_currentStep].currentState!.validate())
                      return null;
                    else {
                      setState(() {
                        _currentStep = step;
                      });
                      _setFocus();
                    }
                  },
                  steps: <Step>[
                    Step(
                      title: Text("Kime?"),
                      state: _completedSteps[0]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Form(
                        key: _formkeys[0],
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Kime hediye alıyorsunuz?",
                            hintText: "örn: annem, arkadaşım, sevgilim",
                          ),
                          onChanged: (value) => setState(() => alici = value),
                          onFieldSubmitted: (_) => _continueToNextStep(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Bu alan boş bırakılamaz!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Step(
                      title: Text("Neden?"),
                      state: _completedSteps[1]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Form(
                        key: _formkeys[1],
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ne için alıyorsunuz?",
                            hintText: "örn: doğum günü, yılbaşı, mezuniyet",
                          ),
                          onChanged: (value) => setState(() => neden = value),
                          onFieldSubmitted: (_) => _continueToNextStep(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Bu alan boş bırakılamaz!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Step(
                      title: Text("Yaş"),
                      state: _completedSteps[2]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Form(
                        key: _formkeys[2],
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Kaç yaşında?",
                            hintText: "örn: 25",
                          ),
                          onChanged: (value) => setState(() => yas = value),
                          onFieldSubmitted: (_) => _continueToNextStep(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Bu alan boş bırakılamaz!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Step(
                      title: Text("Cinsiyet"),
                      state: _completedSteps[3]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          RadioListTile(
                            title: Text("Kadın"),
                            value: "Kadın",
                            groupValue: cinsiyet,
                            onChanged: (value) {
                              setState(() {
                                cinsiyet = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Erkek"),
                            value: "Erkek",
                            groupValue: cinsiyet,
                            onChanged: (value) {
                              setState(() {
                                cinsiyet = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Diğer"),
                            value: "Diğer",
                            groupValue: cinsiyet,
                            onChanged: (value) {
                              setState(() {
                                cinsiyet = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text("İlgi Alanları"),
                      state: _completedSteps[4]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          Text(
                            "İsteğe bağlı - Daha iyi öneri için ekleyebilirsiniz",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...List.generate(_ilgiAlanlariController.length, (
                            index,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _ilgiAlanlariController[index],
                                      decoration: InputDecoration(
                                        labelText: "İlgi Alanı ${index + 1}",
                                        hintText: "örn: müzik, kitap, spor",
                                      ),
                                      onChanged: (value) {
                                        if (index ==
                                                _ilgiAlanlariController.length -
                                                    1 &&
                                            value.trim().isNotEmpty) {
                                          setState(() {
                                            _ilgiAlanlariController.add(
                                              TextEditingController(),
                                            );
                                          });
                                        }
                                      },
                                      onFieldSubmitted: (_) {
                                        if (index <
                                            _ilgiAlanlariController.length -
                                                1) {
                                          FocusScope.of(context).nextFocus();
                                        } else {
                                          _continueToNextStep();
                                        }
                                      },
                                    ),
                                  ),
                                  if (_ilgiAlanlariController.length > 1)
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _ilgiAlanlariController.removeAt(
                                            index,
                                          );
                                        });
                                      },
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Step(
                      title: Text("Bütçe"),
                      state: _completedSteps[5]
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          Text(
                            "İsteğe bağlı - Boş bırakabilirsiniz",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Maximum fiyat (TL) kaç olsun?",
                              hintText: "örn: 500",
                            ),
                            onChanged: (value) => setState(() => butce = value),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onFieldSubmitted: (_) => _sendData(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_currentStep == 5)
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _sendData,
                  icon: Icon(
                    Icons.send,
                    color: _isFormValid ? Colors.white : Colors.grey,
                  ),
                  label: Text(
                    "Gönder (Enter)",
                    style: GoogleFonts.pangolin(
                      color: _isFormValid ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color.fromARGB(255, 131, 106, 173)
                        : Colors.grey.shade400,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
