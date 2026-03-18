/*import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('connected_devices'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSecurityTip(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'this_device'.tr()),
          const SizedBox(height: 8),
          _buildCurrentDeviceCard(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'other_devices'.tr() + ' (2)', action: _buildRemoveAllButton(context)),
          const SizedBox(height: 8),
          _buildOtherDeviceTile(context, icon: Icons.laptop_mac_outlined, name: 'MacBook Pro', location: 'Paris, France', lastActive: '2_hours_ago'.tr()),
          _buildOtherDeviceTile(context, icon: Icons.tablet_mac_outlined, name: 'iPad Air', location: 'Lyon, France', lastActive: '3_days_ago'.tr()),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'Devices are remembered for 30 days of inactivity. Removing a device will require re-authentication.'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSecurityTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(23),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.green[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('security_tip'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                const SizedBox(height: 4),
                Text('regularly_review_devices'.tr(), style: TextStyle(color: Colors.green[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildRemoveAllButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'remove_all'.tr(),
        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCurrentDeviceCard(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone_iphone, color: Colors.green, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('iPhone 15 Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('current'.tr(), style: TextStyle(color: Colors.green[800], fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Paris, France', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('now'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherDeviceTile(BuildContext context, {
    required IconData icon,
    required String name,
    required String location,
    required String lastActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 28),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(location, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(lastActive, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red[700]),
          onPressed: () {},
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/settings/presentation/cubit/session_cubit.dart';
import 'package:myapp/injection_container.dart';
import 'package:intl/intl.dart';

class ConnectedDevicesPage extends StatefulWidget {
  const ConnectedDevicesPage({super.key});

  @override
  State<ConnectedDevicesPage> createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  @override
  Widget build(BuildContext context) {
    // 1. Provide the Cubit to the widget tree
    return BlocProvider(
      create: (context) =>
      sl<SessionCubit>()
        ..getConnectedDevices(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Connected devices'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          elevation: 0,
          foregroundColor: Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.color,
        ),
        // 2. Use a BlocBuilder to build the UI based on the cubit's state
        body: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            // Show a loading indicator while fetching data
            if (state is SessionLoading || state is SessionInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show an error message if fetching fails
            if (state is SessionFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }

            // Once loaded, build the dynamic UI
            if (state is SessionLoaded) {
              final currentDevice = state.sessions.firstWhere(
                    (s) => s.id == state.currentDeviceId,
                orElse: () => DeviceSession(id: '',
                    deviceName: 'Unknown',
                    lastSeen: DateTime.now()),
              );
              final otherDevices = state.sessions.where((s) =>
              s.id != state.currentDeviceId).toList();

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSecurityTip(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'This device'.tr()),
                  const SizedBox(height: 8),
                  // Pass the current device data
                  _buildCurrentDeviceCard(context, device: currentDevice),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    '${'Other devices'.tr()} (${otherDevices.length})',
                    // Make the "Remove All" button functional
                    action: _buildRemoveAllButton(
                        context, otherDevices.isNotEmpty),
                  ),
                  const SizedBox(height: 8),
                  // Use a Column to build the list of other devices
                  if (otherDevices.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: Text('No other devices'.tr(), style: TextStyle(
                              color: Colors.grey))),
                    )
                  else
                    Column(
                      children: otherDevices.map((device) =>
                          _buildOtherDeviceTile(
                            context,
                            device: device,
                            // Make the delete button functional
                            onDelete: () =>
                                _showDeleteConfirmationDialog(context, device),
                          )
                      ).toList(),
                    ),
                ],
              );
            }
            // Fallback for any other state
            return const SizedBox.shrink();
          },
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16.0),
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
          child: Text(
            'Devices are remembered for 30 days of inactivity. Removing a device will require re-authentication.'
                .tr(),
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // --- DIALOG FOR CONFIRMATION ---
  void _showDeleteConfirmationDialog(BuildContext cubitContext,
      DeviceSession device) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: Text('Logout device'.tr()),
            content: Text('Are you sure logout'.tr(args: [device.deviceName])),
            actions: [
              TextButton(
                child: Text('Cancel'.tr()),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              TextButton(
                child: Text(
                    'Log out'.tr(), style: const TextStyle(color: Colors.red)),
                onPressed: () {
                  // Use the cubit from the context to call the logout method
                  cubitContext.read<SessionCubit>().logoutDevice(device.id);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
    );
  }

  // --- WIDGETS ARE NOW DYNAMIC ---

  Widget _buildSecurityTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(23),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.green[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Security tip'.tr(), style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green[800])),
                const SizedBox(height: 4),
                Text('Regularly review devices'.tr(),
                    style: TextStyle(color: Colors.green[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildRemoveAllButton(BuildContext context, bool isEnabled) {
    return TextButton(
      // Disable the button if there are no other devices
      onPressed: isEnabled ? () {
        // TODO: Implement "Remove All" logic in the cubit
      } : null,
      child: Text(
        'Remove all'.tr(),
        style: TextStyle(color: isEnabled ? Colors.red[700] : Colors.grey,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  // Updated to accept a DeviceSession object
  Widget _buildCurrentDeviceCard(BuildContext context,
      {required DeviceSession device}) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                  Icons.phone_iphone, color: Colors.green, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(device.deviceName, style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            'Current'.tr(), style: TextStyle(color: Colors
                            .green[800], fontSize: 12, fontWeight: FontWeight
                            .bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                          Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Now'.tr(), style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to accept a DeviceSession object and a callback
  Widget _buildOtherDeviceTile(BuildContext context, {
    required DeviceSession device,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          // You can add logic here to show different icons based on deviceName
          child: Icon(
              Icons.laptop_mac_outlined, color: Colors.grey[600], size: 28),
        ),
        title: Text(device.deviceName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            // Format the last seen date
            Text(DateFormat.yMMMd().add_jm().format(device.lastSeen),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red[700]),
          onPressed: onDelete,
        ),
      ),
    );
  }
}