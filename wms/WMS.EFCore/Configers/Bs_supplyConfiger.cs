using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 供应商
    /// </summary>
    internal class Bs_supplyConfiger : IEntityTypeConfiguration<Bs_supply>
    {
        public void Configure(EntityTypeBuilder<Bs_supply> builder)
        {
            builder.ToTable(nameof(Bs_supply));
            builder.HasKey(e => e.supply_id);
            builder.Property(e => e.supply_code).HasColumnType("char(9)").IsRequired();
          
            builder.Property(e => e.supply_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.line_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.supply_type_code).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_tel).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.e_mail).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.stock_duty_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.inbill_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.supply_adr).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.operatoro).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            
            builder.Property(e => e.opetime).HasColumnType("datetime").IsRequired(false);
        }
    }
}
