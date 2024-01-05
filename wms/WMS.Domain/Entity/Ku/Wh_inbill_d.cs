using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 入库管理明细表
    /// </summary>
    public class Wh_inbill_d
    {
        public int inbill_id { get; set; }
        public string item_code { get; set; }
        public string inbill_code { get; set; }
        public string item_type { get; set; }
        public string unit { get; set; }
        public Decimal buy_num { get; set; }
        public Decimal inbill_num { get; set; }
        public string area_code { get; set; }
        public Decimal buy_price { get; set; }
        public DateTime product_date { get; set; }
        public string batch_no { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public DateTime? update_time { get; set; }
        public string update_by { get; set; }
        public string remark { get; set; }
        public Decimal zong { get; set; }

    }
}
