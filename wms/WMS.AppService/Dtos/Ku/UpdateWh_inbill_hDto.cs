using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.AppService.Dtos.Ku
{
    /// <summary>
    /// 修改入库管理
    /// </summary>
    public class UpdateWh_inbill_hDto
    {
        //入库单号
        public int inbill_code { get; set; }
        //入库类型
        public string inbill_type { get; set; }
        //入库状态
        public string inbill_state { get; set; }
        //入库日期
        public DateTime inbll_date { get; set; }
        //关联进货单号
        public string buy_code { get; set; }
        public string supply_code { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }
        public string inbill_duty_man { get; set; }
        public string remark { get; set; }
       
        public DateTime? update_time { get; set; }
        public string update_by { get; set; }
        public string sure_state { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
      
        public string ware_name { get; set; }
       
        
    }
}
