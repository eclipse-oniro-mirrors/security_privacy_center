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

import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import Constants from '../constants/ComConstant';
import { GlobalContext } from '../utils/GlobalContext';

@Component
export default struct TitleBar {
  private context = getContext(this) as common.UIAbilityContext;
  @Prop title: string = '';
  @State isBackOnTouch: boolean = false;
  @Prop isSplitMode: boolean = false;
  onBackClick?: () => void;
  /**
   * 外界宿主设置执行Pop动作
   */
  onBackInSettings(): void {
  console.info('TitleBar', 'onBackInSettings');
  const intent: Record<string, Object> = { 'action': 'pop' };
  try {
    GlobalContext.getContext().getSession()?.sendData(intent);
  } catch (e) {
    console.error('TitleBar', `onBack catch err. code:${e?.code} message:${e?.message}`);
  }
}

  build() {
    //   In column mode, the homepage does not display a return button
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Row() {
          Image($r('app.media.ic_back'))
            .fillColor($r('sys.color.ohos_id_color_primary'))
            .objectFit(ImageFit.Contain)
            .height(Constants.TITLE_BAR_IMAGE_HEIGHT)
            .width(Constants.TITLE_BAR_IMAGE_WIDTH)
            .draggable(false)
        }
        .width(Constants.CLICK_SHADOW_LENGTH)
        .height(Constants.CLICK_SHADOW_LENGTH)
        .borderRadius(Constants.CLICK_SHADOW_LENGTH/2)
        .flexShrink(0)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .visibility(this.isSplitMode ? Visibility.None : Visibility.Visible)
        .backgroundColor(this.isBackOnTouch ? $r('sys.color.ohos_id_color_click_effect') : "#d9e2e2e2")
        .hoverEffect(HoverEffect.Highlight)
        .onTouch(event => {
          if (event === undefined) {
            return;
          }
          if (event.type === TouchType.Down) {
            this.isBackOnTouch = true;
          }
          if (event.type === TouchType.Up) {
            this.isBackOnTouch = false;
          }
        })
        .onClick(() => {
          let length = router.getLength();
          Number(length) === 1 ? this.onBackInSettings(): router.back();
        })

        Text(JSON.parse(this.title))
          .align(Alignment.Start)
          .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
          .maxLines(Constants.MAXIMUM_HEADER_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxFontSize(this.isSplitMode ? $r('sys.float.ohos_id_text_size_headline7') : $r('sys.float.ohos_id_text_size_headline8'))
          .minFontSize(14)
          .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
          .flexGrow(Constants.FLEX_GROW)
          .fontWeight(FontWeight.Medium)
          .margin({ left: this.isSplitMode ? 12 : 4 })
      }
    }
    .height(Constants.TITLE_BAR_HEIGHT)
    .constraintSize({ minHeight: Constants.TITLE_BAR_MIN_HEIGHT })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}
