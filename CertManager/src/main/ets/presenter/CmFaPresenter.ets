/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import picker from '@ohos.file.picker';
import router from '@ohos.router';
import certManagerModel from '../model/CertMangerModel';
import FileIoModel from '../model/FileIoModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import { BusinessError } from '@ohos.base';
import { RouterFileVo, RouterAppUidVo } from '../model/CertManagerVo/RouterInfoVo';
import checkUserAuthModel from '../model/CheckUserAuthModel';
import CmInstallPresenter from './CmInstallPresenter';
import FilterParams from '../common/constants/FileFilterParams';

const TAG = 'CMFaPresenter: ';
const gridCountNum: number = 4;

export default class CmFaPresenter {
  private static sInstance: CmFaPresenter;

  public static getInstance(): CmFaPresenter {
    if (CmFaPresenter.sInstance == null) {
      CmFaPresenter.sInstance = new CmFaPresenter();
    }
    return CmFaPresenter.sInstance;
  }

  onAboutToAppear(): void {

  }

  aboutToDisappear(): void {
  }

  unrecognizedFileTips(): void {
    AlertDialog.show({
      message: $r('app.string.Install_Error_NOT_FOUND'),
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: $r('app.float.wh_value_0'), dy: $r('app.float.wh_value_0')
      },
      gridCount: gridCountNum,
      primaryButton: {
        value: $r('app.string.OK'),
        action: () => {
        }
      },
    })
  }

  routeToNextInstallCert(fileUri: string): void {
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.debug(TAG, 'suffix = ', suffix);
        if ((suffix === 'cer') || (suffix === 'pem') || (suffix === 'crt') || (suffix === 'der')) {
          CmInstallPresenter.getInstance().installCert(fileUri, '', suffix, true);
        } else {
          this.unrecognizedFileTips();
        }
      }
    })
  }

  routeToNextInstallEvidence(fileUri: string): void {
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.debug(TAG, 'suffix = ', suffix);
        if ((suffix === 'p12') || (suffix === 'pfx')) {
          let fileInfo = new RouterFileVo(fileUri, suffix);
          router.pushUrl({
            url: 'pages/certPwdInput',
            params: fileInfo
          })
        } else {
          this.unrecognizedFileTips();
        }
      }
    })
  }

  startInstallCert(context: Context): void {
    if (context === undefined || context === null) {
      console.error(TAG + 'startInstallCert, context is undefined');
      return;
    }
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = FilterParams.MAX_SELECT_FILE_NUM;
      documentSelectOptions.fileSuffixFilters = FilterParams.CERT_FILE_SUFFIX;
      let documentPicker = new picker.DocumentViewPicker(context);
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallCert(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  startInstallEvidence(context: Context): void {
    if (context === undefined || context === null) {
      console.error(TAG + 'startInstallEvidence, context is undefined');
      return;
    }
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = FilterParams.MAX_SELECT_FILE_NUM;
      documentSelectOptions.fileSuffixFilters = FilterParams.CREDENTIAL_FILE_SUFFIX;
      let documentPicker = new picker.DocumentViewPicker(context);
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallEvidence(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  startRequestAuth(uri: string): void {
    let appUidInfo = new RouterAppUidVo(uri);
    router.pushUrl({
      url: 'pages/requestAuth',
      params: appUidInfo
    });
  }

  uninstallAllCert(): void {
    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, (errCode: CMModelErrorCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.info(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA success');
      } else {
        console.error(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA failed');
      }
    });

    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode: CMModelErrorCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.info(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED success');
      } else {
        console.error(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED failed');
      }
    });
  }

  startInstall(installType: string, fileUri: string) {
    if (installType === 'CACert') {
      let titleStr = getContext().resourceManager.getStringSync($r('app.string.Identity_Authentication'));
      checkUserAuthModel.auth(titleStr, (authResult: boolean) => {
        if (authResult) {
          console.info('checkUserAuth success');
          this.routeToNextInstallCert(fileUri);
        }
      })
    } else if (installType === 'userCred') {
      AppStorage.setOrCreate('installSystemCred', false);
      AppStorage.setOrCreate('installUserCred', true);
      this.routeToNextInstallEvidence(fileUri);
    } else if (installType === 'systemCred') {
      AppStorage.setOrCreate('installSystemCred', true);
      AppStorage.setOrCreate('installUserCred', false);
      this.routeToNextInstallEvidence(fileUri);
    } else {
      console.error(TAG, 'The installType is not supported');
    }
  }
}