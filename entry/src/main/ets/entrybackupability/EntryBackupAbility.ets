import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup(): Promise<void> {
    console.info('[EntryBackupAbility] onBackup');
  }

  async onRestore(bundleVersion: BundleVersion): Promise<void> {
    console.info(`[EntryBackupAbility] onRestore, version: ${bundleVersion}`);
  }
}
