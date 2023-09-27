/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import router from '@system.router';
import certManagerModel from '../model/CertMangerModel';
import FileIoModel from '../model/FileIoModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';

const TAG = 'CMFaPresenter: ';
const PAGE_URI_PWD_INPUT = 'pages/certPwdInput';
const PAGE_URI_ALIAS_INPUT = 'pages/certInstallAliasInput';

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

  routeToNext(fileUri: string): void {
    console.info(TAG + 'routeToNext fileUri: ' + fileUri);
    FileIoModel.getMediaFileSuffix(fileUri, (suffix) => {
      if (suffix) {
        if ((suffix === 'cer') || (suffix === 'pem')) {
          router.push({
            uri: PAGE_URI_ALIAS_INPUT,
            params: {
              uri: fileUri,
              suffix: suffix
            }
          });
        } else {
          router.push({
            uri: PAGE_URI_PWD_INPUT,
            params: {
              uri: fileUri,
              suffix: suffix
            }
          });
        }
      }
    });
  }

  startInstall(): void {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNext(String(documentSelectResult[0]));
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err) => {
        console.error(TAG + 'documentPicker.select failed with err:' + err);
      });
    } catch (err) {
      console.error(TAG + 'DocumentViewPicker failed with err:' + err);
    }
  }

  startRequestAuth(uri): void {
    router.replace({
      uri: 'pages/requestAuth', params: {
        appUid: uri,
      }
    });
  }

  uninstallAllCert(): void {
    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, (errCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA success');
      } else {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA failed');
      }
    });

    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED success');
      } else {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED failed');
      }
    });
  }
}