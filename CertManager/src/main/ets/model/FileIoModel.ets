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

import fileUri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

export class FileIoModel {
  getMediaFileData(mediaUri: string, callback: Function): void {
    console.info('CertManager FA getMediaFile start');
    let file: fs.File | undefined = undefined;
    try {
      file = fs.openSync(mediaUri, fs.OpenMode.READ_ONLY);
      let stat = fs.statSync(file.fd);
      let buf = new ArrayBuffer(Number(stat.size));
      let num = fs.readSync(file.fd, buf);
      console.info('CertManager FA getMediaFile success');
      callback(new Uint8Array(buf));
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error('CertManager FA getMediaFileData failed with err, message: ' + e.message + ', code: ' + e.code);
      callback(undefined);
    } finally {
      try {
        if (file !== undefined && file !== null) {
          fs.closeSync(file.fd);
        }
      } catch (err) {
        let e: BusinessError = err as BusinessError;
        console.error('CertManager FA close io stream failed with err, message: ' + e.message + ', code: ' + e.code);
      }
    }
  }

  getMediaFileSuffix(mediaUri: string, callback: Function): void {
    try {
      console.info('CertManager FA getMediaFileSuffix start');
      let uri = new fileUri.FileUri(mediaUri);
      let suffix = uri.name.substring(uri.name.lastIndexOf('.') + 1);
      let suffixLowerCase = suffix.toLowerCase();
      callback(suffixLowerCase);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error('CertManager FA getMediaFileSuffix failed with err, message: ' + e.message + ', code: ' + e.code);
      callback(undefined);
    }
  }
}

let fileIoModel = new FileIoModel();

export default fileIoModel as FileIoModel;
