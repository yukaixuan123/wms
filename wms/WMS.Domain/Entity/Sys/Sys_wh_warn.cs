using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sys
{
    /// <summary>
    /// 库存预警设置
    /// </summary>
    public class Sys_wh_warn
    {
        //预警id
        public int warn_id {  get; set; }
        //预警天数
        public int warn_day { get; set; }
        //预警通知人
        public string notice_man { get; set; }
        //预警时间段
        public DateTime warn_time {  get; set; }
    }
}
