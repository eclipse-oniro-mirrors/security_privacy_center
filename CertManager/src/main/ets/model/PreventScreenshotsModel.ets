/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import { GlobalContext } from '../common/GlobalContext';

const TAG: string = 'PreventScreenshotsModel';

export default class PreventScreenshotsModel {
  private static sInstance: PreventScreenshotsModel;

  public static getInstance(): PreventScreenshotsModel {
    if (PreventScreenshotsModel.sInstance == null) {
      PreventScreenshotsModel.sInstance = new PreventScreenshotsModel();
    }
    return PreventScreenshotsModel.sInstance;
  }

  PreventScreenshots(flag: boolean) {
    let windowClass: window.Window | undefined = undefined;
    let isPrivacyMode: boolean = flag;
    try {
      window.getLastWindow(GlobalContext.getContext().getCmContext(), (err: BusinessError, data) => {
        const errCode: number = err.code;
        if (errCode) {
          console.error(TAG, 'Failed to obtain the top window.Cause: ' + JSON.stringify(err));
          return;
        }
        windowClass = data;
        console.info(TAG, 'Success in obtaining the top window.Data');
        try {
          windowClass.setWindowPrivacyMode(isPrivacyMode, (err: BusinessError) => {
            const errCode: number = err.code;
            if (errCode) {
              console.error(TAG, 'Failed to set window to privacy mode.Cause: ' + JSON.stringify(err));
              return;
            }
            console.info(TAG, 'Success in setting the window to privacy mode');
          });
        } catch (exception) {
          console.error(TAG, 'Failed to set the window to privacy mode.Cause: ' + JSON.stringify(exception));
        }
      })
    } catch (exception) {
      console.error(TAG, 'Failed to obtain the top window.Cause' + JSON.stringify(exception));
    }
  }
}