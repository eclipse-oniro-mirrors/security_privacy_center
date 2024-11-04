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
import { CaSystemDetailPage } from '../detail/CaSystemDetailPage';
import { CaUserDetailPage } from '../detail/CaUserDetailPage';
import { CredSystemDetailPage } from '../detail/CredSystemDetailPage';
import { CredUserDetailPage } from '../detail/CredUserDetailPage';
import { AuthorizedAppManagementPage } from '../detail/AuthorizedAppManagementPage';
import { CredPwdInputPage } from '../detail/CredPwdInputPage';
import Want from '@ohos.app.ability.Want';
import deviceInfo from '@ohos.deviceInfo';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { TrustedEvidence } from '../trustedCa';
import { evidenceList } from '../cerEvidenceFa';
import { CertInstallFromStorage } from '../certInstallFromStorage';
import window from '@ohos.window';
import { SheetParam } from '../../common/util/SheetParam';
import uiExtensionHost from '@ohos.uiExtensionHost';
import { BusinessError } from '@ohos.base';
import PreventScreenshotsPresenter from '../../model/PreventScreenshotsModel';

const TAG: string = 'CertManagerSheetFa:';

let storage = LocalStorage.getShared();

const PAGE_MAIN: number = 1;
const PAGE_CA_CERTIFICATE: number = 2;
const PAGE_CREDENTIAL: number = 3;
const PAGE_INSTALL_CERTIFICATE: number = 4;
const PAGE_TYPE: string = 'pageType';

const BOTTOM_SHEET_MIN_PERCENT = 0.6;
const CENTER_SHEET_MAX_PERCENT = 0.9;
const CENTER_SHEET_MIN_HEIGHT = 560;

interface AvoidAreaParam {
  type: window.AvoidAreaType;
  area: window.AvoidArea;
}

@Entry(storage)
@Component
export struct CertManagerSheetFa {
  private sheetSession: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private want: Want = storage.get<Want>('want') as Want;
  private preventScreenshotsPresenter: PreventScreenshotsPresenter = PreventScreenshotsPresenter.getInstance();

  @State @Watch('onSheetPageChanged') private stack: NavPathStack = new NavPathStack();
  @State private sheetParam: SheetParam = new SheetParam();
  @State private pageType: number = PAGE_MAIN;
  @State private maxSheetPageHeight: number = 0;
  @State private rootWidth: number = 0;
  @State private rootHeight: number = 0;
  @State private statusBarHeight: number = 0;
  @State private aiBarHeight: number = 0;

  private avoidAreaChangedCallback: Callback<AvoidAreaParam> = (avoidArea) => {
    if (avoidArea.type === window.AvoidAreaType.TYPE_SYSTEM) {
      this.statusBarHeight = px2vp(avoidArea.area.topRect.height);
      this.updateSheetHeightLimit();
    } else if (avoidArea.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      this.aiBarHeight = px2vp(avoidArea.area.bottomRect.height);
      this.updateSheetHeightLimit();
    } else {
      console.warn(TAG + 'avoidAreaChangedCallback, sheet type is invalid:' + this.sheetParam.sheetType);
    }
  }

  onSheetPageChanged(): void {
    let allPageArray = this.stack.getAllPathName();
    if (allPageArray === undefined || allPageArray.length === 0) {
      this.preventScreenshotsPresenter.PreventScreenshots(false, this.sheetSession);
      this.sheetParam.lastSheetPage = '';
      return;
    }
    let lastPage = allPageArray[allPageArray.length - 1];
    this.sheetParam.lastSheetPage = lastPage;
    if (lastPage !== NavEntryKey.CRED_PWD_INPUT_ENTRY) {
      this.preventScreenshotsPresenter.PreventScreenshots(false, this.sheetSession);
      return;
    }
    this.preventScreenshotsPresenter.PreventScreenshots(true, this.sheetSession);
  }

  aboutToAppear(): void {
    this.registerAvoidChangedListener();
    const parameters = this.want?.parameters;
    if (parameters === undefined || parameters[PAGE_TYPE] === undefined) {
      console.warn(TAG + 'page type param is undefined');
      return;
    }
    this.pageType = parameters[PAGE_TYPE] as number;
    console.log(TAG + 'page type = ' + this.pageType);
  }

  aboutToDisappear(): void {
    this.unregisterAvoidChangedListener();
  }

  initStatusBarHeight(extWindow: uiExtensionHost.UIExtensionHostWindowProxy): void {
    try {
      let avoidArea: window.AvoidArea = extWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      if (avoidArea === undefined) {
        console.warn(TAG + 'initStatusBarHeight, avoid area is undefined');
      }
      this.statusBarHeight = px2vp(avoidArea.topRect.height);
    } catch (err) {
      let error = err as BusinessError;
      console.error(TAG + 'initStatusBarHeight, occur error:' + error?.code + ', msg:' + error?.message);
    }
  }

  initAiBarHeight(extWindow: uiExtensionHost.UIExtensionHostWindowProxy): void {
    try {
      let avoidArea: window.AvoidArea = extWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      if (avoidArea === undefined) {
        console.warn(TAG + 'initAiBarHeight, avoid area is undefined');
      }
      this.aiBarHeight = px2vp(avoidArea.bottomRect.height);
    } catch (err) {
      let error = err as BusinessError;
      console.error(TAG + 'initAiBarHeight, occur error:' + error?.code + ', msg:' + error?.message);
    }
  }

  registerAvoidChangedListener(): void {
    try {
      let extWindow: uiExtensionHost.UIExtensionHostWindowProxy = this.sheetSession?.getUIExtensionHostWindowProxy();
      if (extWindow === undefined) {
        console.error(TAG + 'registerAvoidChangedListener, get extra window is undefined');
        return;
      }
      this.initStatusBarHeight(extWindow);
      this.initAiBarHeight(extWindow);
      extWindow.on('avoidAreaChange', this.avoidAreaChangedCallback);
    } catch (err) {
      let error = err as BusinessError;
      console.error(TAG + 'registerAvoidChangedListener, occur error:' + error?.code + ', msg:' + error?.message);
    }
  }

  unregisterAvoidChangedListener(): void {
    try {
      let extWindow: uiExtensionHost.UIExtensionHostWindowProxy = this.sheetSession?.getUIExtensionHostWindowProxy();
      if (extWindow === undefined) {
        console.error(TAG + 'unregisterAvoidChangedListener, get extra window is undefined');
        return;
      }
      extWindow.off('avoidAreaChange', this.avoidAreaChangedCallback);
    } catch (err) {
      let error = err as BusinessError;
      console.error(TAG + 'unregisterAvoidChangedListener, occur error:' + error?.code + ', msg:' + error?.message);
    }
  }

  private updateSheetHeightLimit(): void {
    if (this.rootHeight === 0) {
      return;
    }
    if (this.sheetParam.sheetType === SheetType.BOTTOM) {
      this.maxSheetPageHeight = this.rootHeight - this.statusBarHeight - 8;
      this.sheetParam.sheetMinHeight = this.rootHeight * BOTTOM_SHEET_MIN_PERCENT;
    } else if (this.sheetParam.sheetType === SheetType.CENTER) {
      let shortSide = Math.min(this.rootWidth, (this.rootHeight - this.statusBarHeight - this.aiBarHeight));
      this.maxSheetPageHeight = shortSide * CENTER_SHEET_MAX_PERCENT;
      this.sheetParam.sheetMinHeight = CENTER_SHEET_MIN_HEIGHT;
    } else {
      console.warn(TAG + 'updateSheetHeightLimit, sheet type is invalid:' + this.sheetParam.sheetType);
    }
  }

  @Builder
  private routerMap(name: string, param?: Object) {
    if (name === NavEntryKey.CA_CERTIFICATE_ENTRY) {
      CaCertPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CREDENTIAL_LIST_ENTRY) {
      CredListPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.INSTALL_ENTRY) {
      InstallPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CA_SYSTEM_DETAIL_ENTRY) {
      CaSystemDetailPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CA_USER_DETAIL_ENTRY) {
      CaUserDetailPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CRED_SYSTEM_DETAIL_ENTRY) {
      CredSystemDetailPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CRED_USER_DETAIL_ENTRY) {
      CredUserDetailPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.AUTHORIZED_APP_ENTRY) {
      AuthorizedAppManagementPage({
        sheetParam: this.sheetParam
      })
    } else if (name === NavEntryKey.CRED_PWD_INPUT_ENTRY) {
      CredPwdInputPage({
        sheetParam: this.sheetParam
      })
    }
  }

  build() {
    Column() {
      Column() {
      }.bindSheet(true, this.buildContent(), {
        height: SheetSize.FIT_CONTENT,
        preferType: ['2in1', 'tablet'].includes(deviceInfo.deviceType) ? SheetType.CENTER : null,
        showClose: true,
        onTypeDidChange: (type) => {
          this.sheetParam.sheetType = type;
          console.log(TAG + 'sheet type:' + this.sheetParam.sheetType);
          if (this.rootHeight === 0) {
            return;
          }
          this.updateSheetHeightLimit();
        },
        onDisappear: () => {
          console.debug(TAG + 'Sheet page disappear, session is undefined?' + (this.sheetSession === undefined));
          this.sheetSession?.sendData({'action': 'exit'})
        }
      })
    }
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100)
    .onAreaChange((oldArea, newArea) => {
      this.rootWidth = newArea.width as number;
      this.rootHeight = newArea.height as number;
      this.updateSheetHeightLimit();
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
    .height(WidthPercent.WH_AUTO)
    .constraintSize({
      maxHeight: this.maxSheetPageHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  private buildHomePage() {
    Column() {
      CertificateComponent({
        isStartBySheet: true,
        sheetParam: this.sheetParam,
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
    .height(WidthPercent.WH_AUTO)
  }

  @Builder
  private buildCaCertPage() {
    Column() {
      TrustedEvidence({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        sheetParam: this.sheetParam,
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
    .height(WidthPercent.WH_AUTO)
  }

  @Builder
  private buildCredListPage() {
    Column() {
      evidenceList({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        sheetParam: this.sheetParam,
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
    .height(WidthPercent.WH_AUTO)
  }

  @Builder
  private buildInstallPage() {
    Column() {
      CertInstallFromStorage({
        isStartBySheetFirst: true,
        isStartBySheet: true,
        sheetParam: this.sheetParam,
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
    .height(WidthPercent.WH_AUTO)
  }
}