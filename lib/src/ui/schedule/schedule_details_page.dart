import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/models/schedule.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';

class ScheduleDetailsPage extends StatelessWidget {
  static const routeName = 'schedule_details';
  const ScheduleDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat().addPattern("EEEE dd/MM hh'h'mm");
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    final worship = args.objParam as Worship;
    final schedule = worship.schedule;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                StringHelper.capitalize(fmt.format(worship.dateTime)),
                style: Theme.of(context).textTheme.headline6,
              ),
              Text('${worship.description}'),
              SizedBox(height: 16.0),
              _cardSchedule(context, schedule),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardSchedule(context, Schedule schedule) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _scheduleTile(
                  context,
                  'Ministro de louvor',
                  schedule.leadSinger,
                  divider: false,
                  hide: false,
                ),
                _scheduleTile(context, 'Backvocais', schedule.backingVocals),
                _scheduleTile(
                  context,
                  'Tecladista',
                  schedule.keyboard,
                  hide: false,
                ),
                _scheduleTile(context, 'Baterista', schedule.drums),
                _scheduleTile(context, 'Guitarrista', schedule.guitar),
                _scheduleTile(context, 'Violonista', schedule.acoustGuitar),
                _scheduleTile(context, 'Baixista', schedule.bass),
                _scheduleTile(
                    context, 'Músico reserva', schedule.backupMusician),
                _scheduleTile(context, 'Cantor reserva', schedule.backupVocal),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: schedule.toString())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_outlined),
              SizedBox(width: 8.0),
              Text('COPIAR'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scheduleTile(context, String title, String name,
      {bool divider = true, hide = true}) {
    return LayoutBuilder(
      builder: (_, constrains) {
        if (hide && (name == null || name.isEmpty)) {
          return Container(height: 0.0, width: 0.0);
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              children: [
                if (divider) Divider(height: 0.0, color: Colors.grey[400]),
                // SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: constrains.maxWidth * 0.4,
                      child: Text(title,
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Text('|',
                        style:
                            TextStyle(color: Colors.grey[300], fontSize: 18)),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      width: constrains.maxWidth * 0.5,
                      child: Text(name ?? '',
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
