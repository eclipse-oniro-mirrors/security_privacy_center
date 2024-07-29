/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { WidthPercent } from '../../common/util/ConfigData';
import { CertificateComponent } from '../certManagerFa';
import { NavEntryKey } from '../../common/NavEntryKey';
import { CaCertPage } from './CaCertPage';
import { CredListPage } from './CredListPage';
import { InstallPage } from './InstallPage';
import { CaSystemDetailPage } from './CaSystemDetailPage';
import { CaUserDetailPage } from './CaUserDetailPage';
import { CredSystemDetailPage } from './CredSystemDetailPage';
import { CredUserDetailPage } from './CredUserDetailPage';
import { AuthorizedAppManagementPage } from './AuthorizedAppManagementPage';
import { CredPwdInputPage } from './CredPwdInputPage';
import Want from '@ohos.app.ability.Want';
import deviceInfo from '@ohos.deviceInfo';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { TrustedEvidence } from '../trustedCa';
import { evidenceList } from '../cerEvidenceFa';
import { CertInstallFromStorage } from '../certInstallFromStorage';

const TAG: string = 'CertManagerSheetFa';

let storage = LocalStorage.getShared();

const PAGE_MAIN: number = 1;
const PAGE_CA_CERTIFICATE: number = 2;
const PAGE_CREDENTIAL: number = 3;
const PAGE_INSTALL_CERTIFICATE: number = 4;
const PAGE_TYPE: string = 'pageType';

@Entry(storage)
@Component
export struct CertManagerSheetFa {
  private session: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private want: Want = storage.get<Want>('want') as Want;

  @State private stack: NavPathStack = new NavPathStack();

  @State private pageType: number = PAGE_MAIN;

  aboutToAppear(): void {
    const parameters = this.want?.parameters;
    if (parameters === undefined || parameters[PAGE_TYPE] === undefined) {
      console.warn(TAG + 'page type param is undefined');
      return;
    }
    this.pageType = parameters[PAGE_TYPE] as number;
    console.log(TAG + 'page type = ' + this.pageType);
  }

  @Builder
  private routerMap(name: string, param?: Object) {
    if (name === NavEntryKey.CA_CERTIFICATE_ENTRY) {
      CaCertPage()
    } else if (name === NavEntryKey.CREDENTIAL_LIST_ENTRY) {
      CredListPage()
    } else if (name === NavEntryKey.INSTALL_ENTRY) {
      InstallPage()
    } else if (name === NavEntryKey.CA_SYSTEM_DETAIL_ENTRY) {
      CaSystemDetailPage()
    } else if (name === NavEntryKey.CA_USER_DETAIL_ENTRY) {
      CaUserDetailPage()
    } else if (name === NavEntryKey.CRED_SYSTEM_DETAIL_ENTRY) {
      CredSystemDetailPage()
    } else if (name === NavEntryKey.CRED_USER_DETAIL_ENTRY) {
      CredUserDetailPage()
    } else if (name === NavEntryKey.AUTHORIZED_APP_ENTRY) {
      AuthorizedAppManagementPage()
    } else if (name === NavEntryKey.CRED_PWD_INPUT_ENTRY) {
      CredPwdInputPage()
    }
  }

  build() {
    Column() {
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
    .bindSheet(true, this.buildContent(), {
      height: SheetSize.FIT_CONTENT,
      preferType: ['2in1', 'tablet'].includes(deviceInfo.deviceType) ? SheetType.CENTER : null,
      showClose: this.stack.size() === 0,
      shouldDismiss: ((sheetDismiss: SheetDismiss) => {
        sheetDismiss.dismiss();
        this.session?.sendData({'action': 'exit'})
      })
    })
  }

  @Builder
  private buildContent() {
    Navigation(this.stack) {
      if (this.pageType === PAGE_CA_CERTIFICATE) {
        this.buildCaCertPage()
      } else if (this.pageType === PAGE_CREDENTIAL) {
        this.buildCredListPage()
      } else if (this.pageType === PAGE_INSTALL_CERTIFICATE) {
        this.buildInstallPage()
      } else {
        this.buildHomePage()
      }
    }
    .hideTitleBar(true)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .navDestination(this.routerMap)
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  private buildHomePage() {
    Column() {
      CertificateComponent({
        isStartBySheet: true,
        selected: (path) => {
          if (path === undefined || path === null || path.length === 0) {
            console.warn(TAG + 'buildHomePage, empty path');
            return;
          }
          this.stack.pushPath(new NavPathInfo(path, ''));
        }
      })
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
  }

  @Builder
  private buildCaCertPage() {
    Column() {
      TrustedEvidence({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        selected: (path, param) => {
          if (path === undefined || path === null || path.length === 0) {
            console.warn(TAG + 'buildCaCertPage, empty path');
            return;
          }
          if (path === NavEntryKey.POP) {
            this.stack?.pop();
          } else {
            this.stack?.pushPath(new NavPathInfo(path, param));
          }
        }
      })
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
  }

  @Builder
  private buildCredListPage() {
    Column() {
      evidenceList({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        selected: (path, param) => {
          if (path === undefined || path === null || path.length === 0) {
            console.warn(TAG + 'buildCredListPage, empty path');
            return;
          }
          if (path === NavEntryKey.POP) {
            this.stack?.pop();
          } else {
            this.stack?.pushPath(new NavPathInfo(path, param));
          }
        }
      })
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
  }

  @Builder
  private buildInstallPage() {
    Column() {
      CertInstallFromStorage({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        selected: (path, param) => {
          if (path === undefined || path === null || path.length === 0) {
            console.warn(TAG + 'buildInstallPage, empty path');
            return;
          }
          if (path === NavEntryKey.POP) {
            this.stack?.pop();
          } else {
            this.stack?.pushPath(new NavPathInfo(path, param));
          }
        }
      })
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
  }
}