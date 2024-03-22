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

import ViewModel from '../model/locationServicesImpl/LocationViewModel';
import Logger from '../common/utils/Logger';
import HeadComponent from '../common/components/headComponent';
import HiSysEventUtil from '../common/utils/HiSysEventUtil';
import HiSysEventConstant from '../common/constants/HiSysEventConstant';

const TAG:string = 'LocationServicesPage'

/**
 * LocationServices
 */
@Entry
@Component
struct LocationServices {
  @StorageLink('LocationServiceStatus') locationServiceStatus: boolean = false;

  build() {
    Column() {
      GridContainer({ gutter: 24, margin: 24}) {
        Column() {
          HeadComponent({ headName: $r('app.string.locationServicesTab'), isActive: true });

          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text($r('app.string.positionInformation'))
              .fontColor($r("app.color.font_color_182431"))
              .fontStyle(FontStyle.Normal)
              .fontSize($r("app.float.location_font_size"))
              .margin({ left: $r('app.float.distance_12') })

            Toggle({ type: ToggleType.Switch, isOn: this.locationServiceStatus })
              .margin({ right: $r('app.float.padding_or_margin_s') })
              .width('36vp')
              .height('20vp')
              .selectedColor('#007DFF')
              .onChange((isOn: boolean) => {
                Logger.info(TAG, 'location service status is :' + this.locationServiceStatus);
                if (isOn) {
                  ViewModel.enableLocation();
                  HiSysEventUtil.reportLocationClick(HiSysEventConstant.BUNDLE_NAME, 1)

                } else {
                  ViewModel.disableLocation();

                  HiSysEventUtil.reportLocationClick(HiSysEventConstant.BUNDLE_NAME, 0)
                }
              });
          }
          .margin({ top: $r("app.float.padding_or_margin_m") })
          .height($r('app.float.wh_value_56'))
          .backgroundColor($r("app.color.white_bg_color"))
          .borderRadius($r("sys.float.ohos_id_corner_radius_default_l"))
        }
        .useSizeType({
          sm: { span: 4, offset: 0 },
          md: { span: 6, offset: 1 },
          lg: { span: 8, offset: 2 }
        })
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'location service about to appear');
    ViewModel.initViewModel();
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'location service about to disappear');
  }
}