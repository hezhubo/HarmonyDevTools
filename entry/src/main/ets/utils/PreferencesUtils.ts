import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';

export class PreferencesUtils {
  private static mPreferences: dataPreferences.Preferences = null;

  static init(context: Context, name: string) {
    try {
      this.mPreferences = dataPreferences.getPreferencesSync(context.getApplicationContext(), { name: name });
    } catch (err) {
      console.error(`Failed to get preferences sync. Code:${err.code}, message:${err.message}`);
    }
  }

  static getPreferences(): dataPreferences.Preferences | null {
    return this.mPreferences;
  }

  static put(key: string, value: string | number | boolean) {
    if (this.mPreferences != null) {
      try {
        this.mPreferences.put(key, value, (err, val) => {
          if (err) {
            return;
          }
          this.mPreferences.flush().then();
        });
      } catch (e) {
        console.error(e.message);
      }
    }
  }

  static getString(key: string, defValue: string = ""): string {
    if (this.mPreferences != null) {
      try {
        let value = this.mPreferences.getSync(key, null);
        if (value != null && typeof value == 'string') {
          return value;
        }
      } catch (e) {
        console.error(e.message);
      }
    }
    return defValue;
  }

  static getNumber(key: string, defValue: number = 0): number {
    if (this.mPreferences != null) {
      try {
        let value = this.mPreferences.getSync(key, null);
        if (value != null && typeof value == 'number') {
          return value;
        }
      } catch (e) {
        console.error(e.message);
      }
    }
    return defValue;
  }

  static getBoolean(key: string, defValue: boolean = false): boolean {
    if (this.mPreferences != null) {
      try {
        let value = this.mPreferences.getSync(key, null);
        if (value != null && typeof value == 'boolean') {
          return value;
        }
      } catch (e) {
        console.error(e.message);
      }
    }
    return defValue;
  }

}