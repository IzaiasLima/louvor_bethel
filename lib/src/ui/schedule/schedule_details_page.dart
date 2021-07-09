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
              _cardSchedule(context, schedule),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardSchedule(context, Schedule schedule) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _scheduleTile(context, 'Ministro de louvor', schedule.leadSinger),
            _scheduleTile(context, 'Backvocais', schedule.backingVocals),
            _scheduleTile(context, 'Tecladista', schedule.keyboard),
            _scheduleTile(context, 'Baterista', schedule.drums),
            _scheduleTile(context, 'Guitarrista', schedule.guitar),
            _scheduleTile(context, 'Violonista', schedule.acoustGuitar),
            _scheduleTile(context, 'Baixista', schedule.bass),
            _scheduleTile(context, 'Músico reserva', schedule.backupMusician),
            _scheduleTile(context, 'Cantor reserva', schedule.backupVocal,
                divider: false),
          ],
        ),
      ),
    );
  }

  Widget _scheduleTile(context, String title, String name,
      {bool divider = true}) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: constrains.maxWidth * 0.4,
                    child: Text(title,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  Text('|',
                      style: TextStyle(color: Colors.grey[300], fontSize: 18)),
                  Container(
                    padding: EdgeInsets.only(left: 8.0),
                    width: constrains.maxWidth * 0.5,
                    child: Text(name ?? '',
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ),
              SizedBox(height: 6.0),
              if (divider) Divider(height: 0.0, color: Colors.grey[400])
            ],
          ),
        );
      },
    );
  }
}
