import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class EventQRScreen extends StatefulWidget {
  const EventQRScreen({super.key});

  @override
  State<EventQRScreen> createState() => _EventQRScreenState();
}

class _EventQRScreenState extends State<EventQRScreen> {
  final _eventTitleFormKey = GlobalKey<FormState>();
  final _eventLocationFormKey = GlobalKey<FormState>();
  final _eventSummaryFormKey = GlobalKey<FormState>();

  var eventTitleInput = TextEditingController();
  var eventStartDateInput =
      TextEditingController(text: DateFormat('d/M/y').format(DateTime.now()));
  var eventEndDateInput =
      TextEditingController(text: DateFormat('d/M/y').format(DateTime.now()));
  var eventStartTimeInput = TextEditingController(
    text: TimeOfDay.now()
        .toString()
        .replaceAll('TimeOfDay(', '')
        .replaceAll(')', ''),
  );
  var eventEndTimeInput = TextEditingController(
    text: TimeOfDay(
      hour: TimeOfDay.now().hour + 1,
      minute: TimeOfDay.now().minute,
    ).toString().replaceAll('TimeOfDay(', '').replaceAll(')', ''),
  );
  var eventLocationInput = TextEditingController();
  var eventSummaryInput = TextEditingController();

  String? qrData;
  String? eventTitle;
  String? eventLocation;
  String? eventSummary;
  bool isAllDay = false;
  DateTime? startDate = DateTime.now();
  TimeOfDay? startTime = TimeOfDay.now();
  DateTime? endDate = DateTime.now();
  TimeOfDay? endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    String? startDateTime = DateFormat('yyyyMMddTHHmmss').format(
      DateTime(startDate!.year, startDate!.month, startDate!.day,
          startTime!.hour, startTime!.minute, 00),
    );

    String? endDateTime = DateFormat('yyyyMMddTHHmmss').format(
      DateTime(endDate!.year, endDate!.month, endDate!.day, endTime!.hour,
          endTime!.minute, 00),
    );

    String? allDayStartDate = DateFormat('yyyyMMdd').format(
      DateTime(startDate!.year, startDate!.month, startDate!.day),
    );

    String? allDayEndDate = DateFormat('yyyyMMdd').format(
      DateTime(endDate!.year, endDate!.month, endDate!.day),
    );

    Widget generateButton() {
      if (eventTitle != null && _eventTitleFormKey.currentState!.validate()) {
        String eventString() {
          String formattedEventString = '';
          formattedEventString += 'BEGIN:VEVENT\n';
          formattedEventString += 'SUMMARY:${eventTitle!}\n';

          if (isAllDay == false) {
            formattedEventString += 'DTSTART:${startDateTime}Z\n';
            formattedEventString += 'DTEND:${endDateTime}Z\n';
          } else {
            formattedEventString += 'DTSTART;VALUE=DATE:$allDayStartDate\n';
            formattedEventString += 'DTEND;VALUE=DATE:$allDayEndDate\n';
          }

          if (eventLocation != null) {
            formattedEventString += 'LOCATION:${eventLocation!}\n';
          }

          if (eventSummary != null) {
            formattedEventString += 'DESCRIPTION:${eventSummary!}\n';
          }

          formattedEventString += 'END:VEVENT';
          return formattedEventString;
        }

        qrData = eventString();
      }

      if (qrData != null &&
          eventTitle != null &&
          _eventTitleFormKey.currentState!.validate()) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: eventTitle!,
                itemRawData: qrData!,
              );
              Navigator.pushNamed(
                context,
                '/generate-qr-result',
                arguments: {
                  'typeName': typeName,
                  'qrData': qrData,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text('Generate QR Code'),
          ),
        );
      } else {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text('Generate QR Code'),
          ),
        );
      }
    }

    Widget dateTimeTextFieldWidget() {
      if (isAllDay == false) {
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Text(
                            'Start Time',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: eventStartTimeInput,
                        keyboardType: TextInputType.datetime,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: startTime!,
                            confirmText: 'Confirm',
                            cancelText: 'Cancel',
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null) {
                            String formattedTime = pickedTime
                                .toString()
                                .replaceAll('TimeOfDay(', '')
                                .replaceAll(')', '');
                            setState(() {
                              startTime = pickedTime;
                              eventStartTimeInput.text = formattedTime;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Enter start time',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Text(
                            'End Time',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: eventEndTimeInput,
                        keyboardType: TextInputType.datetime,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: endTime!,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null) {
                            String formattedTime = pickedTime
                                .toString()
                                .replaceAll('TimeOfDay(', '')
                                .replaceAll(')', '');
                            setState(() {
                              endTime = pickedTime;
                              eventEndTimeInput.text = formattedTime;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Enter end time',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      } else {
        return const SizedBox();
      }
    }

    var calendarConfig = CalendarDatePicker2WithActionButtonsConfig(
      openedFromDialog: true,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      controlsHeight: 80,
      calendarType: CalendarDatePicker2Type.single,
      calendarViewMode: DatePickerMode.day,
      controlsTextStyle: const TextStyle(
        color: Color.fromARGB(255, 114, 114, 114),
        fontSize: 16,
      ),
      customModePickerButtonIcon: const Icon(
        Icons.arrow_drop_down,
        color: Color.fromARGB(255, 114, 114, 114),
      ),
      yearTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      selectedYearTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      selectedDayHighlightColor: Theme.of(context).primaryColor,
      lastMonthIcon: const Icon(
        Icons.arrow_back_ios_new,
        color: Color.fromARGB(255, 114, 114, 114),
        size: 18,
      ),
      nextMonthIcon: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromARGB(255, 114, 114, 114),
        size: 18,
      ),
      weekdayLabelTextStyle: const TextStyle(
        color: Color.fromARGB(255, 114, 114, 114),
      ),
      dayTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      okButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          'Confirm',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cancelButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      buttonPadding: const EdgeInsets.all(0),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          typeName,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Title',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _eventTitleFormKey,
                child: TextFormField(
                  controller: eventTitleInput,
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: ValidationBuilder(
                    requiredMessage: 'Title cannot be empty',
                  ).required().build(),
                  onChanged: (value) {
                    setState(() {
                      eventTitle = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    _eventTitleFormKey.currentState!.validate();
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter title',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: isAllDay == true
                  ? MaterialStatePropertyAll(Theme.of(context).primaryColor)
                  : const MaterialStatePropertyAll(
                      Color.fromARGB(255, 235, 235, 235),
                    ),
              value: isAllDay,
              onChanged: (value) {
                setState(() {
                  isAllDay = value!;
                });
              },
            ),
            Text(
              'All Day Event',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          'Start Date',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      showCursor: false,
                      controller: eventStartDateInput,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        var pickedDate = await showCalendarDatePicker2Dialog(
                          context: context,
                          dialogSize: const Size(370, 450),
                          initialValue: [startDate!],
                          borderRadius: BorderRadius.circular(24),
                          config: calendarConfig,
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('d/M/y').format(pickedDate.first!);
                          setState(() {
                            startDate = pickedDate.first!;
                            eventStartDateInput.text = formattedDate;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: 'Enter start date',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          'End Date',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      showCursor: false,
                      controller: eventEndDateInput,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        var pickedDate = await showCalendarDatePicker2Dialog(
                          context: context,
                          dialogSize: const Size(370, 450),
                          initialValue: [endDate!],
                          borderRadius: BorderRadius.circular(24),
                          config: calendarConfig,
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('d/M/y').format(pickedDate.first!);
                          setState(() {
                            endDate = pickedDate.first;
                            eventEndDateInput.text = formattedDate;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: 'Enter end date',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          dateTimeTextFieldWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Location',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _eventLocationFormKey,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  controller: eventLocationInput,
                  keyboardType: TextInputType.text,
                  autofillHints: const [AutofillHints.location],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      eventLocation = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter location',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Summary',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _eventSummaryFormKey,
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: eventSummaryInput,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      eventSummary = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter summary',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: generateButton(),
      ),
    );
  }
}
