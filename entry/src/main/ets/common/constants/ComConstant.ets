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

export default class Constants {
  //TITLE_BAR
  static TITLE_BAR_HEIGHT = 56;
  static TITLE_BAR_MIN_HEIGHT = 56;
  static TITLE_BAR_IMAGE_HEIGHT = 24;
  static TITLE_BAR_IMAGE_WIDTH = 24;
  static TITLE_BAR_MARGIN_RIGHT = 4;
  //public property style
  static FLEX_GROW = 1;
  static MAXIMUM_HEADER_LINES = 2;
  static DEFAULT_MARGIN_START = 12;
  static DEFAULT_MARGIN_END = 12;
  static CLICK_SHADOW_LENGTH = 48;
  static CONSTRAIN_MIN_HEIGHT = 48;
  //sliding style
  static SLIDING_THRESHOLD = 160
  //duration style
  static DURATION_TIME = 300
  static DURATION_TIME_250 = 250
  // with height style
  static WIDTH_HEIGHT_FULL_SCREEN = '100%'
  static NO_RESULT_HEIGHT = '80%'
  // padding style
  static BOOK_MARK_PADDING_BOTTOM = 50
  //lineHeight style
  static LINE_HEIGHT_S = 13
  static LINE_HEIGHT_M = 19
  static LINE_HEIGHT_L = 21
  // bar max width
  static GRID_ROW_XS = 4
  static GRID_ROW_SM = 6
  static GRID_ROW_MD = 8
  static GRID_ROW_XS_LG = 10
  //PermissionListView style
  static OPACITY = 0.2
  static STROKE_WIDTH_HALF = 0.5
  static FONT_FAMILY_HARMONY_HEI_TI = 'HarmonyHeiTi'
  //grid useSizeType
  static GUTTER = 0;
  //line point
  static START_POINT = -4
  static END_POINT = 30
  //breakpoints size
  static XS_BREAKPOINTS_NUMBER = 320;
  static MD_BREAKPOINTS_NUMBER = 520;
  static LG_BREAKPOINTS_NUMBER = 840;
  static XS_BREAKPOINTS = '320vp';
  static MD_BREAKPOINTS = '520vp';
  static LG_BREAKPOINTS = '840vp';
  // store key
  static INIT_APP_INFO_LIST = 'initAppInfoList';
  static IGNORE_LOCK_SCREEN_PASSWORD_ADVICE_COUNT = 'ignoreLockScreenPasswordAdviceCount';
  static IGNORE_ADVICE_MAX_COUNT = 2;
  // segmentation button width
  static BUTTON_BACKGROUND_WIDTH_ONE = 102;
  static BUTTON_BACKGROUND_WIDTH_TWO = 140;
  static SEGMENTATION_BUTTON_WIDTH = 448;
  // column row space
  static DEFAULT_SPACE = 12;
  // domain
  static DOMAIN = 0x0000;
  static STORAGE_KEY_SESSION = 'session';
  //device type
  static DEVICE_TYPE_PC = '2in1';
  static DEVICE_TYPE_TABLET = 'tablet';
  static STORAGE_KEY_CURRENT_PAGE_ROUTE = 'currentPageRoute';
  //last %d days
  static BAR_CHART_DAYS = 3;
  static ACCESS_RECORD_DAYS = 7;
}