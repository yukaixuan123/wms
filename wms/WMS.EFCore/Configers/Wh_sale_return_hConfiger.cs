using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Pc;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 销售退货主表
    /// </summary>
    internal class Wh_sale_return_hConfiger : IEntityTypeConfiguration<Wh_sale_return_h>
    {
        public void Configure(EntityTypeBuilder<Wh_sale_return_h> builder)
        {
            builder.ToTable(nameof(Wh_sale_return_h));
            builder.HasKey(e => e.sr_codeId);
            builder.Property(e => e.sr_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.sr_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.sale_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.cust_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_way).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sale_duty_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime").IsRequired();
          
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired();
          
            builder.Property(e => e.return_money).HasColumnType("decimal(18,2)").IsRequired();
           
        }
    }
}
