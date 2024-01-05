using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.KC
{
    /// <summary>
    /// 库存表
    /// </summary>
    public class Wh_now_storage
    {
        public int now_storage_id { get; set; }
        public string ware_code { get; set; }
        public string area_code { get; set; }
        public string item_code { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal plan_outnum { get; set; }
       
    }
}
