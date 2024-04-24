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

import hilog from '@ohos.hilog';

const FONT_SIZE_50 = 50;
const FONT_SIZE_20 = 20;
const MARGIN_20 = 20;
const WIDTH_35_100 = '35%';
const WIDTH_5_100 = '5%';
const WIDTH_100 = '100%';

@Entry
@Component
struct Index {
  aboutToAppear() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility index aboutToAppear');
  }

  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(FONT_SIZE_50)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('next page')
            .fontSize(FONT_SIZE_20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: MARGIN_20
        })
        .backgroundColor('#0D9FFB')
        .width(WIDTH_35_100)
        .height(WIDTH_5_100)
        .onClick(() => {
        })
      }
      .width(WIDTH_100)
    }
    .height(WIDTH_100)
  }
}