/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import certManagerModel from '../model/CertMangerModel';
import FileIoModel from '../model/FileIoModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import router from '@system.router';

const TAG = 'CMInstallPresenter: ';

export default class CmInstallPresenter {
  private static sInstance: CmInstallPresenter;
  optType: CMModelOptType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;

  public static getInstance(): CmInstallPresenter {
    if (CmInstallPresenter.sInstance == null) {
      CmInstallPresenter.sInstance = new CmInstallPresenter();
    }
    return CmInstallPresenter.sInstance;
  }

  onAboutToAppear(): void {

  }

  aboutToDisappear(): void {
    this.optType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;
  }

  updateCertFileType(suffix): void {
    console.info(TAG + 'updateCertFileType suffix: ' + suffix);
    if ((suffix === 'cer') || (suffix === 'pem')) {
      this.optType = CMModelOptType.CM_MODEL_OPT_USER_CA;
    } else if ((suffix === 'p12') || (suffix === 'jks') || (suffix === 'pfx')) {
      this.optType = CMModelOptType.CM_MODEL_OPT_APP_CRED;
    }
  }

  getFileDataFromUri(uri, callback): void {
    FileIoModel.getMediaFileData(uri, (data) => {
      callback(data);
    });

  }

  installCert(uri, alias, suffix): void {
    this.updateCertFileType(suffix);
    this.getFileDataFromUri(uri, (data) => {
      certManagerModel.installCertOrCred(this.optType, alias, data, globalThis.PwdStore.getCertPwd(), (errCode) => {
        console.info(TAG + 'installCertOrCred result: ' + JSON.stringify(errCode));
        globalThis.PwdStore.clearCertPwd();
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          console.info(TAG + 'installCert success');
        } else {
          console.info(TAG + 'installCert failed');
        }
        router.clear();
        router.replace({ uri: 'pages/certManagerFa' });
      });
    });
  }
}