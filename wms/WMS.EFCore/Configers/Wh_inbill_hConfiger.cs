using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 入库管理表
    /// </summary>
    internal class Wh_inbill_hConfiger : IEntityTypeConfiguration<Wh_inbill_h>
    {
        public void Configure(EntityTypeBuilder<Wh_inbill_h> builder)
        {
            builder.ToTable(nameof(Wh_inbill_h));
            builder.HasKey(e => e.inbill_code);
            builder.Property(e => e.inbill_code).IsRequired();
            builder.Property(e => e.inbill_type).HasColumnType("char(10)").IsRequired(false);
            builder.Property(e => e.inbill_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.inbll_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.buy_code).HasColumnType("char(16)").IsRequired(false);
            builder.Property(e => e.supply_code).HasColumnType("char(9)").IsRequired(false);
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_way).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.inbill_duty_man).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime").IsRequired(false); 
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime").IsRequired(false);
            builder.Property(e => e.ware_name).HasMaxLength(50).IsUnicode(false).IsRequired(false);
           
            builder.Property(e => e.inbill_bh).HasColumnType("char(8)").IsRequired(false);
           
            

        }
    }
}
